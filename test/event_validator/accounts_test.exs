defmodule EventValidator.AccountsTest do
  use EventValidator.DataCase

  alias EventValidator.Accounts

  describe "users" do
    alias EventValidator.Accounts.User

    @valid_attrs %{
      email: "email@email.com",
      password: "some encrypted_password",
      name: "some name"
    }
    @invalid_attrs %{email: "not an email", password: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
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
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "email@email.com"

      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
