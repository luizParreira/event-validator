defmodule EventValidatorWeb.Plug.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> put_view(EventValidatorWeb.ErrorView)
    |> render("unauthorized.json")
    |> halt()
  end
end
