defmodule EventValidatorWeb.SourceView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.{SourceView, EventSchemaView}

  def render("index.json", %{sources: sources}) do
    %{data: render_many(sources, SourceView, "source.json")}
  end

  def render("show.json", %{source: source}) do
    %{data: render_one(source, SourceView, "source.json")}
  end

  def render("source.json", %{source: source}) do
    events = EventValidator.Events.list_event_schemas(source.id)
    source = EventValidator.Repo.preload(source, [:source_token])

    %{
      id: source.id,
      name: source.name,
      token: source.source_token.token,
      events: render_many(events, EventSchemaView, "event_schema.json")
    }
  end
end
