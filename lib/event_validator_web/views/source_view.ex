defmodule EventValidatorWeb.SourceView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.SourceView

  def render("index.json", %{sources: sources}) do
    %{data: render_many(sources, SourceView, "source.json")}
  end

  def render("show.json", %{source: source}) do
    %{data: render_one(source, SourceView, "source.json")}
  end

  def render("source.json", %{source: source}) do
    %{id: source.id, name: source.name, token: source.source_token.token}
  end
end
