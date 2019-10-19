defmodule EventValidator.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EventValidator.Repo
  alias Ecto.Multi

  alias EventValidator.Accounts.{User, Organization, UserOrganization}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Returns `{:error, :not_found} if the User does not exist.

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, :not_found}

  """
  def get_user(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}

      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Gets a single user.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user_by_email("some@email.com")
      {:ok, %User{}}

      iex> get_user_by_email("some-other@email.com")
      nil

  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end


  @doc """
  Gets a single user based on their reset password token

  Returns `{:error, :not_found}` if the User with the given does not exist.

  ## Examples

      iex> get_user_by_reset_password_token("some-token")
      %User{}

      iex> get_user_by_reset_password_token("inexistent-token")
      nil

  """
  def get_user_by_reset_password_token(token) do
    Repo.get_by(User, reset_password_token: token)
  end

  @doc """
  Verify a users password and email.

  Returns `{:error, :unauthorized}` if the data is not verified

  ## Examples

      iex> verify_user("some@email.com", "some-password")
      {:ok, %User{}}

      iex> verify_user("some-other@email.com", "password")
      nil

  """
  def verify_user(email, password) do
    case get_user_by_email(email) do
      %User{} = user ->
        Argon2.check_pass(user, password, hash_key: :encrypted_password)

      nil ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Updates user attributes for the given params

  ## Examples
    iex> Accounts.update_user(user, %{name: "John"})
    {:ok, %User{}}

    iex> Accounts.update_user(user, %{name: nil})
    {:error, %Ecto.Changeset{}}

  """
  def update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  @doc """
  Sets a reset_password_token and sends an email to the user containing the token if it exists

  ## Examples

      iex> reset_user_password("existent@email.com")
      {:ok}

      iex> reset_user_password("inexistent@email.com")
      {:error, :not_found}

  """
  def reset_user_password(email) do
    case get_user_by_email(email) do
      nil ->
        {:error, :not_found}

      user ->
        user |> set_reset_password_token
        {:ok}
    end
  end

  defp set_reset_password_token(user) do
    token =
      :crypto.strong_rand_bytes(50)
      |> Base.url_encode64()
      |> binary_part(0, 50)

    user
    |> User.changeset(%{reset_password_token: token})
    |> Repo.update()
  end

  @doc """
  Returns the list of organizations based on an user_id.

  ## Examples

      iex> list_organizations(user_id: 10)
      [%Organization{}, ...]

  """
  def list_organizations(user_id: user_id) do
    case Repo.all(
           from u in User,
             where: u.id == ^user_id,
             preload: [:organizations]
         ) do
      [user] -> user.organizations
      [] -> []
      nil -> []
    end
  end

  @doc """
  Gets a single organization and all its sources.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id),
    do:
      Organization
      |> Repo.get!(id)
      |> Repo.preload([:sources])

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_organization(%{field: value}, 10)
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value}, 10)
      {:error, %Ecto.Changeset{}}
  """

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def create_organization(attrs, user_id) do
    multi_struct =
      Multi.new()
      |> Multi.insert(:organization, Organization.changeset(%Organization{}, attrs))
      |> Multi.run(:user_organization, fn _, %{organization: organization} ->
        %UserOrganization{}
        |> UserOrganization.changeset(%{user_id: user_id, organization_id: organization.id})
        |> Repo.insert()
      end)

    case Repo.transaction(multi_struct) do
      {:ok, %{organization: organization, user_organization: _user_org}} ->
        {:ok, organization}

      {:error, :user_organization, user_org_changeset, _changes_so_far} ->
        {:error, user_org_changeset}

      {:error, :organization, org_changeset, _changes_so_far} ->
        {:error, org_changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{source: %Organization{}}

  """
  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end

  @doc """
  Creates a user_organization.

  ## Examples

      iex> create_user_organization(%{field: value})
      {:ok, %UserOrganization{}}

      iex> create_user_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_organization(attrs \\ %{}) do
    %UserOrganization{}
    |> UserOrganization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_organization changes.

  ## Examples

      iex> change_user_organization(user_organization)
      %Ecto.Changeset{source: %UserOrganization{}}

  """
  def change_user_organization(%UserOrganization{} = user_organization) do
    UserOrganization.changeset(user_organization, %{})
  end
end
