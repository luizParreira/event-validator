defmodule EventValidatorWeb.ValidateControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{Projects, Accounts, Events}
  alias Projects.Source

  @source_attrs %{
    name: "some name",
    platform: "some platform",
    organization_id: nil
  }
  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }
  @org_attrs %{
    name: "some name",
    size: "1-10",
    website: "some website"
  }

  @params %{
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

  def fixture(:source) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)

    {:ok, %Source{id: id} = source} =
      Projects.create_source(%{@source_attrs | organization_id: organization.id})

    {:ok, _event_schema} =
      Events.create_event_schema(%{
        name: "Click Buy",
        source_id: id,
        schema: %{"json" => "schema"}
      })

    source
  end

  setup %{conn: conn} do
    Verk.Queue.clear("default")
    source = fixture(:source)

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("auth-token", source.source_token.token),
     source: source}
  end

  describe "create source" do
    test "renders no content valid when token present", %{conn: conn, source: source} do
      conn = post(conn, "/validate", @params)
      assert conn.status == 204

      {:ok, [%Verk.Job{class: "EventValidator.Validations.Worker", args: [id, params]}]} =
        Verk.Queue.range("default")

      assert id == source.id
      assert params == @params
    end

    test "renders auth error when token invalid", %{conn: conn} do
      conn = put_req_header(conn, "auth-token", "wrong-token")
      conn = post(conn, "/validate")

      assert json_response(conn, 401) == %{"errors" => %{"title" => "UnauthorizedRequest"}}
    end
  end
end
