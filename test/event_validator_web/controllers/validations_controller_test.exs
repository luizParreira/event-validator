defmodule EventValidatorWeb.ValidationsControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{Events, Accounts, Projects, JWT, Validations}

  @event_params %{
    "anonymousId" => "other-anynonus-id",
    "timestamp" => "2017-04-28T20:51:55.463",
    "type" => "track",
    "userId" => 10,
    "event" => "Click Buy",
    "properties" => %{
      "userId" => 10,
      "anoymousId" => "an-anonymous-Id",
      "productId" => "a-product-id",
      "productType" => "a-type",
      "price" => 100
    }
  }

  @valid_schema %{
    "type" => "object",
    "required" => ["event", "properties"],
    "properties" => %{
      "event" => %{
        "type" => "string"
      },
      "properties" => %{
        "type" => "object",
        "properties" => %{
          "anonymousId" => %{"type" => "string"},
          "price" => %{"type" => "number"}
        },
        "required" => [
          "anonymousId",
          "price"
        ]
      }
    }
  }

  @invalid_event_params %{
    "type" => "track",
    "userId" => 10,
    "event" => "Click Buy",
    "properties" => %{
      "userId" => 10
    }
  }

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @event_schema_attrs %{
    name: "some name",
    schema: @valid_schema,
    confirmed: true,
    source_id: nil
  }

  @validation_attrs %{
    event_params: @event_params,
    valid: false,
    event_schema_id: nil
  }

  @source_attrs %{
    name: "some name",
    organization_id: nil
  }

  @org_attrs %{
    name: "some name",
    website: "some website"
  }

  def setup_fixture do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)
    {:ok, source} = Projects.create_source(%{@source_attrs | organization_id: organization.id})
    {:ok, schema} = Events.create_event_schema(%{@event_schema_attrs | source_id: source.id})

    {user, organization, source, schema}
  end

  setup %{conn: conn} do
    {user, organization, source, schema} = setup_fixture()
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token),
     organization: organization,
     source: source,
     schema: schema}
  end

  describe "index" do
    test "lists all invalid validations", %{
      conn: conn,
      organization: org,
      source: source,
      schema: schema
    } do
      {:ok, _validation} =
        Validations.create_schema_validation(%{
          @validation_attrs
          | event_params: @invalid_event_params,
            event_schema_id: schema.id
        })

      {:ok, _validation1} =
        Validations.create_schema_validation(%{
          @validation_attrs
          | event_params: %{event: "event"},
            event_schema_id: schema.id
        })

      {:ok, _validation2} =
        Validations.create_schema_validation(%{
          @validation_attrs
          | valid: true,
            event_schema_id: schema.id
        })

      conn = get(conn, Routes.validations_path(conn, :index), %{organization_id: org.id})

      assert json_response(conn, 200)["data"] == [
               %{
                 "event_schema_id" => schema.id,
                 "source_id" => source.id,
                 "error_count" => 1,
                 "error_message" => "Required properties anonymousId, price were not present.",
                 "event" => "some name",
                 "path" => "#/properties"
               },
               %{
                 "event_schema_id" => schema.id,
                 "source_id" => source.id,
                 "error_count" => 1,
                 "error_message" => "Required property properties was not present.",
                 "event" => "some name",
                 "path" => "#"
               }
             ]
    end
  end

  describe "unauhtorized request" do
    test "renders unauthorized json", %{conn: conn, organization: org} do
      conn =
        conn
        |> put_req_header("authorization", "bearer: token")
        |> get(Routes.validations_path(conn, :index), %{organization_id: org.id})

      assert json_response(conn, 401)["errors"] == %{"title" => "UnauthorizedRequest"}
    end
  end

  describe "bad request" do
    test "renders bad request when the payload is incorrect", %{conn: conn} do
      conn = get(conn, Routes.validations_path(conn, :index), other: %{invalid: "payload"})

      assert json_response(conn, 400)["errors"] == %{"title" => "BadRequest"}
    end
  end
end
