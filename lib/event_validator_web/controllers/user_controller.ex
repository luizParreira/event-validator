defmodule EventValidatorWeb.UserController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts
  alias EventValidator.Accounts.User

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end
end
