defmodule EventValidator.ProjectsTest do
  use EventValidator.DataCase

  alias EventValidator.{Projects, Accounts}

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @org_attrs %{
    name: "some name",
    website: "some website"
  }

  @source_valid_attrs %{name: "some name", organization_id: nil}

  def source_fixture(attrs \\ %{}) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)

    {:ok, source} =
      attrs
      |> Enum.into(%{@source_valid_attrs | organization_id: organization.id})
      |> Projects.create_source()

    source
  end

  describe "sources" do
    alias EventValidator.Projects.Source

    @invalid_attrs %{name: nil, platform: nil}

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert Projects.list_sources() == [source]
    end

    test "get_source/1 returns the source with given id" do
      source = source_fixture()
      assert Projects.get_source(source.id) == source
    end

    test "create_source/1 with valid data creates a source" do
      assert {:ok, %Source{} = source} = {:ok, source_fixture()}
      assert source.name == "some name"
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_source(@invalid_attrs)
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = Projects.change_source(source)
    end
  end

  describe "source_tokens" do
    alias EventValidator.Projects.SourceToken

    @valid_attrs %{token: "some token", source_id: nil}
    @invalid_attrs %{token: nil}

    def source_token_fixture(attrs \\ %{}) do
      source = source_fixture()

      {:ok, source_token} =
        attrs
        |> Enum.into(%{@valid_attrs | source_id: source.id})
        |> Projects.create_source_token()

      source_token
    end

    test "get_source_token!/1 returns the source_token with given id" do
      source_token = source_token_fixture()
      assert Projects.get_source_token!(source_token.id) == source_token
    end

    test "create_source_token/1 with valid data creates a source_token" do
      assert {:ok, %SourceToken{} = source_token} = {:ok, source_token_fixture()}
      assert source_token.token == "some token"
    end

    test "create_source_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_source_token(@invalid_attrs)
    end

    test "change_source_token/1 returns a source_token changeset" do
      source_token = source_token_fixture()
      assert %Ecto.Changeset{} = Projects.change_source_token(source_token)
    end
  end
end
