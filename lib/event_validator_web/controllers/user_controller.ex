defmodule EventValidatorWeb.UserController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts
  alias EventValidator.Accounts.User

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      token = EventValidator.JWT.encode_token(user, %{type: "User"})

      conn
      |> put_status(:created)
      |> render("user.json", user: user, token: token)
    end
  end
end
