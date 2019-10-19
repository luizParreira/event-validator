defmodule EventValidatorWeb.EventSchemaControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{Events, Accounts, Projects, JWT}
  alias Events.EventSchema

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @create_attrs %{
    name: "some name",
    schema: %{},
    source_id: nil,
    confirmed: true
  }

  @source_attrs %{
    name: "some name",
    organization_id: nil
  }

  @org_attrs %{
    name: "some name",
    website: "some website"
  }

  @update_attrs %{
    name: "some updated name",
    schema: %{}
  }

  @invalid_attrs %{name: nil, schema: nil, source_id: nil}

  def setup_fixture do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)
    {:ok, source} = Projects.create_source(%{@source_attrs | organization_id: organization.id})
    {user, organization, source}
  end

  def fixture(:event_schema, source) do
    {:ok, event_schema} = Events.create_event_schema(%{@create_attrs | source_id: source.id})
    event_schema
  end

  setup %{conn: conn} do
    {user, _organization, source} = setup_fixture()
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token),
     source: source}
  end

  describe "index" do
    test "lists all event_schemas", %{conn: conn, source: source} do
      {:ok, schema} = Events.create_event_schema(%{@create_attrs | source_id: source.id})
      {:ok, schema2} = Events.create_event_schema(%{@create_attrs | source_id: source.id})
      conn = get(conn, Routes.event_schema_path(conn, :index, %{source_id: source.id}))

      assert json_response(conn, 200)["data"] == [
               %{"id" => schema2.id, "name" => schema2.name, "schema" => schema2.schema},
               %{"id" => schema.id, "name" => schema.name, "schema" => schema.schema}
             ]
    end
  end

  describe "create event_schema" do
    test "renders event_schema when data is valid", %{conn: conn, source: source} do
      conn =
        post(conn, Routes.event_schema_path(conn, :create),
          event_schema: %{@create_attrs | source_id: source.id}
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_schema_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "schema" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_schema_path(conn, :create), event_schema: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event_schema" do
    test "renders event_schema when data is valid", %{
      conn: conn,
      source: source
    } do
      %EventSchema{id: id} = event_schema = fixture(:event_schema, source)

      conn =
        put(conn, Routes.event_schema_path(conn, :update, event_schema),
          event_schema: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_schema_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "schema" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, source: source} do
      event_schema = fixture(:event_schema, source)

      conn =
        put(conn, Routes.event_schema_path(conn, :update, event_schema),
          event_schema: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event_schema" do
    test "deletes chosen event_schema", %{conn: conn, source: source} do
      event_schema = fixture(:event_schema, source)
      conn = delete(conn, Routes.event_schema_path(conn, :delete, event_schema))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_schema_path(conn, :show, event_schema))
      end
    end
  end

  describe "unauhtorized request" do
    test "renders unauthorized json", %{conn: conn} do
      attrs = %{
        email: "some-other@email.com",
        password: "some password",
        name: "some name"
      }

      conn =
        conn
        |> put_req_header("authorization", "bearer: token")
        |> post(Routes.event_schema_path(conn, :create), event_schema: attrs)

      assert json_response(conn, 401)["errors"] == %{"title" => "UnauthorizedRequest"}
    end
  end

  describe "bad request" do
    test "renders bad request when the payload is incorrect", %{conn: conn} do
      conn = post(conn, Routes.event_schema_path(conn, :create), other: %{invalid: "payload"})

      assert json_response(conn, 400)["errors"] == %{"title" => "BadRequest"}
    end
  end
end
