defmodule EventValidatorWeb.AuthController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts

  plug Ueberauth

  action_fallback EventValidatorWeb.FallbackController

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = auth.uid
    password = auth.credentials.other.password
    handle_user_conn(Accounts.verify_user(email, password), conn)
  end

  defp handle_user_conn({:ok, user}, conn) do
    token = EventValidator.JWT.encode_token(user, %{type: "User"})

    conn
    |> put_status(200)
    |> put_view(EventValidatorWeb.UserView)
    |> render("user.json", user: user, token: token)
  end

  defp handle_user_conn({:error, :unauthorized}, _conn) do
    {:error, :unauthorized}
  end
end
