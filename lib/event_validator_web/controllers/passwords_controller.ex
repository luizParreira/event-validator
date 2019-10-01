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
end

