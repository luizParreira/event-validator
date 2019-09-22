defmodule EventValidator.Reports.ReportsEmail do
  use Bamboo.Phoenix, view: EventValidatorWeb.EmailView

  def event_validation_email(%{email_to: email_to, validation_data: validation_data}) do
    new_email()
    |> to(email_to)
    |> from("noreply@validata.app")
    |> subject("Your report is ready!")
    |> put_html_layout({EventValidatorWeb.EmailView, "email.html"})
    |> render("reports.html", data: validation_data)
  end
end
