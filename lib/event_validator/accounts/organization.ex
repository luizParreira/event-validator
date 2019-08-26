defmodule EventValidator.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventValidator.Accounts.UserOrganization
  alias EventValidator.Accounts.User

  schema "organizations" do
    field :name, :string
    field :size, :string
    field :website, :string
    many_to_many :users, User, join_through: UserOrganization

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :website, :size])
    |> validate_required([:name, :size])
    |> validate_inclusion(:size, ["1-10", "11-50", "50-100", "101-500", ">500"])
  end
end
