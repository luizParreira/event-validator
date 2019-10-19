defmodule EventValidator.Accounts.ResetPassrwordEmail do
  use Bamboo.Phoenix, view: EventValidatorWeb.EmailView

  def reset_password_email(%{email_to: email_to, reset_password_token: token}) do
    new_email()
    |> to(email_to)
    |> from("noreply@validata.app")
    |> subject("Your password reset is here")
    |> put_html_layout({EventValidatorWeb.EmailView, "email.html"})
    |> render("reset_password.html", reset_password_token: token)
  end
end
