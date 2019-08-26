defmodule EventValidator.Accounts.UserOrganization do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventValidator.Accounts.User
  alias EventValidator.Accounts.Organization

  @primary_key false
  schema "users_organizations" do
    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(user_organization, attrs) do
    user_organization
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([:user_id, :organization_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:organization_id)
  end
end
