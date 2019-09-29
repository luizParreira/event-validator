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
              website: organization.website,
              sources: []
            }
          end
        )
    }
  end

  def render("show.json", %{organization: organization}) do
    organization =
      EventValidator.Repo.preload(organization, sources: [:source_token, :event_schemas])

    %{
      data: %{
        id: organization.id,
        name: organization.name,
        website: organization.website,
        sources: render_many(organization.sources, SourceView, "source.json")
      }
    }
  end
end
