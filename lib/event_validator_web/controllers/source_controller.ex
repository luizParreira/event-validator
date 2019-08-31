defmodule EventValidatorWeb.SourceController do
  use EventValidatorWeb, :controller

  alias EventValidator.Projects
  alias EventValidator.Projects.{Source, TokenManager, SourceToken}

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, %{"organization_id" => organization_id}) do
    sources = Projects.list_sources(organization_id: organization_id)
    render(conn, "index.json", sources: sources)
  end

  def index(_conn, _), do: {:error, :bad_request}

  def create(conn, %{"source" => source_params}) do
    with {:ok, %Source{} = source} <- Projects.create_source(source_params) do
      conn
      |> put_status(:created)
      |> render("show.json", source: source)
    end
  end
end
