defmodule EventValidatorWeb.OrganizationController do
  use EventValidatorWeb, :controller

  alias EventValidator.Accounts
  alias EventValidator.Accounts.{Organization}

  action_fallback EventValidatorWeb.FallbackController

  def index(conn, _params) do
    user = conn.private.guardian_default_resource

    organizations = Accounts.list_organizations(user_id: user.id)
    render(conn, "index.json", organizations: organizations)
  end

  def show(conn, %{"id" => id}) do
    org = Accounts.get_organization!(id)
    render(conn, "show.json", organization: org)
  end

  def create(conn, %{"organization" => organization_params}) do
    user = conn.private.guardian_default_resource

    with {:ok, %Organization{} = organization} <-
           Accounts.create_organization(organization_params, user.id) do
      conn
      |> put_status(:created)
      |> render("show.json", organization: organization)
    else
      error -> error
    end
  end

  def create(_conn, _params) do
    {:error, :bad_request}
  end
end
