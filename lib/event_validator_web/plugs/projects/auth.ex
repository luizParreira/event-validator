defmodule EventValidatorWeb.Plug.Projects.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias EventValidator.Projects
  alias Projects.{TokenManager, SourceToken}

  defmodule Unauthorized do
    defexception message: "Could not authenticate the webhook caller, look into it"
  end

  def init(options \\ %{}), do: options

  def call(conn, _options \\ %{}) do
    resolve_authentication(conn)
  end

  defp resolve_authentication(conn) do
    token =
      conn
      |> get_req_header("auth-token")
      |> Enum.at(0)

    case TokenManager.decode_token(token) do
      {:ok, source_id} -> get_source_token(conn, source_id)
      _ -> unauthorized(conn)
    end
  end

  defp get_source_token(conn, id) do
    case Projects.get_source_token(source_id: id) do
      nil ->
        unauthorized(conn)

      %SourceToken{source_id: source_id} ->
        assign(conn, :source_id, source_id)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(401)
    |> put_view(EventValidatorWeb.ErrorView)
    |> render("unauthorized.json")
    |> halt()
  end
end
