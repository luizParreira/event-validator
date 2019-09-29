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
    source = EventValidator.Repo.preload(source, [:source_token, :event_schemas])

    %{
      id: source.id,
      name: source.name,
      token: source.source_token.token,
      events: render_many(source.event_schemas, EventSchemaView, "event_schema.json")
    }
  end
end
