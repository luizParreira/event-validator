defmodule EventValidator.EventsTest do
  use EventValidator.DataCase

  alias EventValidator.{Events, Accounts, Projects}

  describe "event_schemas" do
    alias EventValidator.Events.EventSchema

    @event_schema_attrs %{name: "some name", schema: %{}, source_id: nil, confirmed: false}
    @update_attrs %{name: "some updated name", schema: %{}}
    @invalid_attrs %{name: nil, schema: nil, source_id: nil}

    @user_attrs %{
      email: "some@email.com",
      password: "some password",
      name: "some name"
    }

    @source_attrs %{
      name: "some name",
      organization_id: nil
    }

    @org_attrs %{
      name: "some name",
      website: "some website"
    }

    def setup_fixture do
      with {:ok, user} <- Accounts.create_user(@user_attrs),
           {:ok, organization} <- Accounts.create_organization(@org_attrs, user.id),
           {:ok, source} <-
             Projects.create_source(%{@source_attrs | organization_id: organization.id}) do
        source
      end
    end

    def event_schema_fixture(attrs \\ %{}) do
      source = setup_fixture()

      {:ok, event_schema} =
        attrs
        |> Enum.into(%{@event_schema_attrs | source_id: source.id})
        |> Events.create_event_schema()

      event_schema
    end

    test "list_event_schemas/0 returns all event_schemas" do
      event_schema = event_schema_fixture()
      assert Events.list_event_schemas() == [event_schema]
    end

    test "get_event_schema!/1 returns the event_schema with given id" do
      event_schema = event_schema_fixture()
      assert Events.get_event_schema!(event_schema.id) == event_schema
    end

    test "create_event_schema/1 with valid data creates a event_schema" do
      assert {:ok, %EventSchema{} = event_schema} = {:ok, event_schema_fixture()}

      assert event_schema.name == "some name"
      assert event_schema.schema == %{}
    end

    test "create_event_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event_schema(@invalid_attrs)
    end

    test "update_event_schema/2 with valid data updates the event_schema" do
      event_schema = event_schema_fixture()

      assert {:ok, %EventSchema{} = event_schema} =
               Events.update_event_schema(event_schema, @update_attrs)

      assert event_schema.name == "some updated name"
      assert event_schema.schema == %{}
    end

    test "update_event_schema/2 with invalid data returns error changeset" do
      event_schema = event_schema_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Events.update_event_schema(event_schema, @invalid_attrs)

      assert event_schema == Events.get_event_schema!(event_schema.id)
    end

    test "delete_event_schema/1 deletes the event_schema" do
      event_schema = event_schema_fixture()
      assert {:ok, %EventSchema{}} = Events.delete_event_schema(event_schema)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event_schema!(event_schema.id) end
    end

    test "change_event_schema/1 returns a event_schema changeset" do
      event_schema = event_schema_fixture()
      assert %Ecto.Changeset{} = Events.change_event_schema(event_schema)
    end
  end
end
