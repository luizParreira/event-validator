defmodule EventValidator.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventValidator.Accounts.UserOrganization
  alias EventValidator.Accounts.Organization

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string

    field :password, :string, virtual: true

    many_to_many :organizations, Organization, join_through: UserOrganization

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> validate_required([:name, :email])
    |> validate_password
    |> unique_constraint(:email)
    |> validate_format(
      :email,
      ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/,
      message: "Invalid email"
    )
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, hash_key: :encrypted_password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp validate_password(%Ecto.Changeset{valid?: true, changes: %{encrypted_password: nil}} = changeset) do
    changeset|> validate_required([:password])
  end

  defp validate_password(changeset), do: changeset
end
