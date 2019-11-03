defmodule EventValidatorWeb.ValidationsController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts
  alias EventValidator.Reports

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, %{"organization_id" => organization_id}) do
    org = Accounts.get_organization!(organization_id)
    validations = Reports.event_validation_report(org)

    render(conn, "index.json", validations: validations)
  end

  def index(_conn, _), do: {:error, :bad_request}
end
