defmodule EventValidator.Projects.Source do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventValidator.Accounts.Organization
  alias EventValidator.Events.EventSchema

  schema "sources" do
    field :name, :string
    belongs_to :organization, Organization, foreign_key: :organization_id
    has_many :event_schemas, EventSchema

    timestamps()
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
    |> foreign_key_constraint(:organization_id)
  end
end
