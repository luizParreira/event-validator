defmodule EventValidatorWeb.PasswordsController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts

  action_fallback EventValidatorWeb.FallbackController

  def reset_password(conn, %{"email" => email}) do
    case Accounts.reset_user_password(email) do
      {:ok} -> send_resp(conn, 204, "")
      {:error, :not_found} -> send_resp(conn, 404, "")
    end
  end

  def update(conn, %{"token" => token, "password" => password}) do
    case Accounts.get_user_by_reset_password_token(token) do
      nil ->
        send_resp(conn, 404, "")

      user ->
        case Accounts.update_user(user, %{password: password}) do
          {:ok, _} -> send_resp(conn, 201, "")
          {:error, _} -> send_resp(conn, 400, "Error while updating the user")
        end
    end
  end
end
