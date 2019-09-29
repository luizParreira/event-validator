defmodule EventValidatorWeb.EventSchemaController do
  use EventValidatorWeb, :controller

  alias EventValidator.{Events, Projects}
  alias EventValidator.Events.EventSchema

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, %{"source_id" => source_id}) do
    case Projects.get_source(source_id) do
      nil ->
        {:error, :bad_request}
      source ->
        render(conn, "index.json", event_schemas: source.event_schemas)
    end
  end

  def index(_conn, _), do: {:error, :bad_request}

  def create(conn, %{"event_schema" => event_schema_params}) do
    with {:ok, %EventSchema{} = event_schema} <- Events.create_event_schema(event_schema_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_schema_path(conn, :show, event_schema))
      |> render("show.json", event_schema: event_schema)
    end
  end

  def create(_conn, _params) do
    {:error, :bad_request}
  end

  def show(conn, %{"id" => id}) do
    event_schema = Events.get_event_schema!(id)
    render(conn, "show.json", event_schema: event_schema)
  end

  def update(conn, %{"id" => id, "event_schema" => event_schema_params}) do
    event_schema = Events.get_event_schema!(id)

    with {:ok, %EventSchema{} = event_schema} <-
           Events.update_event_schema(event_schema, event_schema_params) do
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
