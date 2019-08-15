defmodule EventValidatorWeb.EventSchemaController do
  use EventValidatorWeb, :controller

  alias EventValidator.Events
  alias EventValidator.Events.EventSchema

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, _params) do
    event_schemas = Events.list_event_schemas()
    render(conn, "index.json", event_schemas: event_schemas)
  end

  def create(conn, %{"event_schema" => event_schema_params}) do
    with {:ok, %EventSchema{} = event_schema} <- Events.create_event_schema(event_schema_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_schema_path(conn, :show, event_schema))
      |> render("show.json", event_schema: event_schema)
    end
  end

  def show(conn, %{"id" => id}) do
    event_schema = Events.get_event_schema!(id)
    render(conn, "show.json", event_schema: event_schema)
  end

  def update(conn, %{"id" => id, "event_schema" => event_schema_params}) do
    event_schema = Events.get_event_schema!(id)

    with {:ok, %EventSchema{} = event_schema} <- Events.update_event_schema(event_schema, event_schema_params) do
      render(conn, "show.json", event_schema: event_schema)
    end
  end

  def delete(conn, %{"id" => id}) do
    event_schema = Events.get_event_schema!(id)

    with {:ok, %EventSchema{}} <- Events.delete_event_schema(event_schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
