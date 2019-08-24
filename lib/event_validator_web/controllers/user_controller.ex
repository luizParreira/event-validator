defmodule EventValidatorWeb.UserController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts
  alias EventValidator.Accounts.User

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      {:ok, token, _} =
        EventValidator.Guardian.encode_and_sign(user, %{type: "User"},
          token_type: :access,
          ttl: {2, :hours}
        )

      conn
      |> put_status(:created)
      |> render("user.json", user: user, token: token)
    end
  end
end
