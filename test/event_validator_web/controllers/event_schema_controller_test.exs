defmodule EventValidatorWeb.EventSchemaControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.Events
  alias EventValidator.Events.EventSchema
  alias EventValidator.JWT

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @create_attrs %{
    name: "some name",
    schema: %{}
  }
  @update_attrs %{
    name: "some updated name",
    schema: %{}
  }
  @invalid_attrs %{name: nil, schema: nil}

  def fixture(:event_schema) do
    {:ok, event_schema} = Events.create_event_schema(@create_attrs)
    event_schema
  end

  setup %{conn: conn} do
    {:ok, user} = EventValidator.Accounts.create_user(@user_attrs)
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token)}
  end

  describe "index" do
    test "lists all event_schemas", %{conn: conn} do
      conn = get(conn, Routes.event_schema_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event_schema" do
    test "renders event_schema when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_schema_path(conn, :create), event_schema: @create_attrs)
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
    setup [:create_event_schema]

    test "renders event_schema when data is valid", %{
      conn: conn,
      event_schema: %EventSchema{id: id} = event_schema
    } do
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

    test "renders errors when data is invalid", %{conn: conn, event_schema: event_schema} do
      conn =
        put(conn, Routes.event_schema_path(conn, :update, event_schema),
          event_schema: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event_schema" do
    setup [:create_event_schema]

    test "deletes chosen event_schema", %{conn: conn, event_schema: event_schema} do
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

  defp create_event_schema(_) do
    event_schema = fixture(:event_schema)
    {:ok, event_schema: event_schema}
  end
end
