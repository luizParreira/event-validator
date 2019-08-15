defmodule EventValidatorWeb.EventSchemaView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.EventSchemaView

  def render("index.json", %{event_schemas: event_schemas}) do
    %{data: render_many(event_schemas, EventSchemaView, "event_schema.json")}
  end

  def render("show.json", %{event_schema: event_schema}) do
    %{data: render_one(event_schema, EventSchemaView, "event_schema.json")}
  end

  def render("event_schema.json", %{event_schema: event_schema}) do
    %{id: event_schema.id,
      name: event_schema.name,
      schema: event_schema.schema}
  end
end
