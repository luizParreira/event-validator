defmodule EventValidatorWeb.SourceView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.{SourceView, EventSchemaView}
  alias EventValidator.Projects.{Source, SourceToken}

  def render("index.json", %{sources: sources}) do
    %{data: render_many(sources, SourceView, "source.json")}
  end

  def render("show.json", %{source: source}) do
    %{data: render_one(source, SourceView, "source.json")}
  end

  def render("source.json", %{
        source: %Source{
          id: id,
          name: name,
          source_token: %SourceToken{token: token},
          event_schemas: event_schemas
        }
      }) do
    %{
      id: id,
      name: name,
      token: token
    }
  end

  def render("source.json", %{source: %Source{id: id, name: name}}) do
    %{id: id, name: name}
  end

  def render("show_with_events.json", %{
        source: %Source{
          id: id,
          name: name,
          source_token: %SourceToken{token: token},
          event_schemas: event_schemas
        }
      }) do
    %{
      data: %{
        id: id,
        name: name,
        token: token,
        events: render_many(event_schemas, EventSchemaView, "event_schema.json")
      }
    }
  end
end
