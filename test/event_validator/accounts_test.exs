defmodule EventValidator.AccountsTest do
  use EventValidator.DataCase

  alias EventValidator.Accounts

  @valid_user_attrs %{
    email: "email@email.com",
    password: "some encrypted_password",
    name: "some name"
  }

  @valid_org_attrs %{name: "some name", website: "some website"}

  describe "users" do
    alias EventValidator.Accounts.User

    @invalid_attrs %{email: "not an email", password: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == {:ok, user}
    end

    test "get_user/1 returns not found error when no user" do
      assert Accounts.get_user(100_000) == {:error, :not_found}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)
      assert user.email == "email@email.com"

      assert {:ok, user} ==
               Argon2.check_pass(user, "some encrypted_password", hash_key: :encrypted_password)

      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "reset_user_password/1 sets an reset password token if it exists with that email" do
      email = "email@validata.app"
      user = user_fixture(email: email)

      assert Accounts.reset_user_password(email) == {:ok}
      assert Accounts.get_user!(user.id).reset_password_token != nil
    end

    test "reset_user_password/1 returns {:error, :not_found} when couldn't found the user by email" do
      email = "inexistent@validata.app"

      assert Accounts.reset_user_password(email) == {:error, :not_found}
    end

    test "get_user_by_reset_password_token/1 returns an user for a given reset password token" do
      token = "valid-token"
      user = user_fixture(reset_password_token: token)

      assert Accounts.get_user_by_reset_password_token(token) == user
    end

    test "get_user_by_reset_password_token/1 returns not found error when no user" do
      assert Accounts.get_user_by_reset_password_token("inexistent-token") == nil
    end
  end

  describe "organizations" do
    alias EventValidator.Accounts.Organization

    @invalid_attrs %{name: nil, website: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_org_attrs)
        |> Accounts.create_organization()

      organization
    end

    test "list_organizations/1 returns all organizations" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      org = organization_fixture()

      {:ok, _user_org} =
        Accounts.create_user_organization(%{user_id: user.id, organization_id: org.id})

      assert Accounts.list_organizations(user_id: 100_000_000) == []
      assert Accounts.list_organizations(user_id: user.id) == [org]
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} =
               Accounts.create_organization(@valid_org_attrs)

      assert organization.name == "some name"
      assert organization.website == "some website"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@invalid_attrs)
    end

    test "create_organization/2 with valid data creates a organization and user_organization association" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)

      assert {:ok, %Organization{} = organization} =
               Accounts.create_organization(@valid_org_attrs, user.id)

      [associated_organization] = Accounts.list_organizations(user_id: user.id)

      assert organization.name == "some name"
      assert organization.website == "some website"
      assert associated_organization == organization
    end

    test "create_organization/2 with valid org data but no user created" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@valid_org_attrs, 0)
    end

    test "create_organization/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@invalid_attrs, 0)
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end

  describe "users_organizations" do
    alias EventValidator.Accounts.UserOrganization

    @valid_attrs %{}
    @invalid_attrs %{}

    def user_organization_fixture(attrs \\ %{}) do
      {:ok, user_organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_organization()

      user_organization
    end

    test "create_user_organization/1 with valid data creates a user_organization" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      {:ok, org} = Accounts.create_organization(@valid_org_attrs)

      assert {:ok,
              %UserOrganization{user_id: user_id, organization_id: org_id} = user_organization} =
               Accounts.create_user_organization(%{user_id: user.id, organization_id: org.id})

      assert [org] == Accounts.list_organizations(user_id: user.id)
    end

    test "create_user_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_organization(@invalid_attrs)
    end

    test "change_user_organization/1 returns a user_organization changeset" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      {:ok, org} = Accounts.create_organization(@valid_org_attrs)
      user_organization = user_organization_fixture(%{user_id: user.id, organization_id: org.id})
      assert %Ecto.Changeset{} = Accounts.change_user_organization(user_organization)
    end
  end
end
