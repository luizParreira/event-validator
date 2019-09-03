defmodule EventValidator.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventValidator.Accounts.UserOrganization
  alias EventValidator.Accounts.User
  alias EventValidator.Projects.Source

  schema "organizations" do
    field :name, :string
    field :website, :string
    many_to_many :users, User, join_through: UserOrganization
    has_many :sources, Source

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :website])
    |> validate_required([:name])
  end
end
