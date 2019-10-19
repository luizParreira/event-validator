defmodule EventValidatorWeb.SourceControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{JWT, Accounts, Projects, Events}

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @create_attrs %{
    name: "some name",
    organization_id: nil
  }

  @org_attrs %{
    name: "some name",
    website: "some website"
  }

  @invalid_attrs %{name: nil, platform: nil}

  def setup_fixture do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)
    {user, organization}
  end

  setup %{conn: conn} do
    {user, organization} = setup_fixture()
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token),
     organization: organization}
  end

  describe "index" do
    test "lists all sources", %{conn: conn, organization: organization} do
      attrs = %{@create_attrs | organization_id: organization.id}
      {:ok, source} = Projects.create_source(attrs)
      source_token = EventValidator.Repo.preload(source, :source_token).source_token

      conn = get(conn, Routes.source_path(conn, :index), %{organization_id: organization.id})

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => source.id,
                 "name" => source.name,
                 "token" => source_token.token,
                 "events" => []
               }
             ]
    end
  end

  describe "show" do
    test "show a source", %{conn: conn, organization: organization} do
      attrs = %{@create_attrs | organization_id: organization.id}
      {:ok, source} = Projects.create_source(attrs)
      source_token = EventValidator.Repo.preload(source, :source_token).source_token

      event_attrs = %{
        name: "some event",
        schema: %{},
        source_id: source.id,
        confirmed: true
      }

      event_attrs_1 = %{
        name: "some event 1",
        schema: %{},
        source_id: source.id,
        confirmed: true
      }

      {:ok, event_schema} = Events.create_event_schema(event_attrs)
      {:ok, event_schema_1} = Events.create_event_schema(event_attrs_1)

      conn = get(conn, Routes.source_path(conn, :show, source.id))

      assert json_response(conn, 200)["data"] ==
               %{
                 "id" => source.id,
                 "name" => source.name,
                 "token" => source_token.token,
                 "events" => [
                   %{
                     "id" => event_schema_1.id,
                     "name" => "some event 1",
                     "schema" => %{}
                   },
                   %{
                     "id" => event_schema.id,
                     "name" => "some event",
                     "schema" => %{}
                   }
                 ]
               }
    end
  end

  describe "create source" do
    test "renders source when data is valid", %{conn: conn, organization: organization} do
      attrs = %{@create_attrs | organization_id: organization.id}
      conn = post(conn, Routes.source_path(conn, :create), source: attrs)

      assert %{"name" => "some name"} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.source_path(conn, :create), source: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
