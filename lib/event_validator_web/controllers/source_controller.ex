defmodule EventValidatorWeb.SourceController do
  use EventValidatorWeb, :controller

  alias EventValidator.Projects
  alias EventValidator.Projects.{Source, TokenManager, SourceToken}

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, _params) do
    sources = Projects.list_sources()
    render(conn, "index.json", sources: sources)
  end

  def create(conn, %{"source" => source_params}) do
    with {:ok, %Source{} = source} <- Projects.create_source(source_params),
         {:ok, %SourceToken{} = source_token} <- TokenManager.encode_token(source) do
      conn
      |> put_status(:created)
      |> render("source.json", source: source, token: source_token.token)
    end
  end
end
