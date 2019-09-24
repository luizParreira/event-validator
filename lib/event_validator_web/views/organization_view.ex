defmodule EventValidatorWeb.OrganizationView do
  use EventValidatorWeb, :view
  alias EventValidatorWeb.SourceView

  def render("index.json", %{organizations: organizations}) do
    %{
      data:
        Enum.map(
          organizations,
          fn organization ->
            %{
              id: organization.id,
              name: organization.name,
              website: organization.website
            }
          end
        )
    }
  end

  def render("show.json", %{organization: organization}) do
    %{
      data: %{
        id: organization.id,
        name: organization.name,
        website: organization.website,
        sources: render_many(organization.sources, SourceView, "source.json")
      }
    }
  end

  def render("organization.json", %{organization: organization}) do
    %{
      data: %{
        id: organization.id,
        name: organization.name,
        website: organization.website
      }
    }
  end
end
