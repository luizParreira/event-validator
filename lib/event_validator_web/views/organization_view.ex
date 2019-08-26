defmodule EventValidatorWeb.OrganizationView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.OrganizationView

  def render("index.json", %{organizations: organizations}) do
    %{data: render_many(organizations, OrganizationView, "organization.json")}
  end

  def render("organization.json", %{organization: organization}) do
    %{
      data: %{
        id: organization.id,
        name: organization.name,
        website: organization.website,
        size: organization.size
      }
    }
  end
end
