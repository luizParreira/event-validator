defmodule EventValidator.ValidationsTest do
  use EventValidator.DataCase

  alias EventValidator.{Projects, Accounts, Events, Validations}
  alias Projects.Source

  describe "schema_validations" do
    alias EventValidator.Validations.SchemaValidation

    @invalid_attrs %{error_schema: nil, valid: nil}

    @source_attrs %{
      name: "some name",
      platform: "some platform",
      organization_id: nil
    }
    @user_attrs %{
      email: "some@email.com",
      password: "some password",
      name: "some name"
    }
    @org_attrs %{
      name: "some name",
      website: "some website"
    }

    @params %{
      "anonymousId" => "other-anynonus-id",
      "timestamp" => "2017-04-28T20:51:55.463",
      "type" => "track",
      "userId" => 10,
      "event" => "Click Buy",
      "properties" => %{
        "userId" => 10,
        "anoymousId" => "an-anonymous-Id",
        "productId" => "a-product-id",
        "productType" => "a-type",
        "price" => 100
      }
    }

    @schema_validation_attrs %{
      valid: true,
      event_schema_id: nil,
      event_params: @params
    }

    def schema_validation_fixture(user_attrs \\ @user_attrs) do
      {:ok, user} = Accounts.create_user(user_attrs)
      {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)

      {:ok, %Source{id: id}} =
        Projects.create_source(%{@source_attrs | organization_id: organization.id})

      {:ok, event_schema} =
        Events.create_event_schema(%{
          name: "Click Buy",
          source_id: id,
          schema: %{"json" => "schema"}
        })

      {:ok, schema_validation} =
        Validations.create_schema_validation(%{
          @schema_validation_attrs
          | event_schema_id: event_schema.id
        })

      {schema_validation, organization}
    end

    test "list_schema_validations/0 returns all schema_validations" do
      {schema_validation, _} = schema_validation_fixture()
      assert Validations.list_schema_validations() == [schema_validation]
    end

    test "get_schema_validation!/1 returns the schema_validation with given id" do
      {schema_validation, _} = schema_validation_fixture()
      assert Validations.get_schema_validation!(schema_validation.id) == schema_validation
    end

    test "create_schema_validation/1 with valid data creates a schema_validation" do
      assert {%SchemaValidation{} = schema_validation, _} = schema_validation_fixture()

      assert schema_validation.event_params == @params
      assert schema_validation.valid == true
    end

    test "create_schema_validation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Validations.create_schema_validation(@invalid_attrs)
    end

    test "list_schema_validations/1 returns the schema_validations from a given organization" do
      {expected_schema_validation, organization} = schema_validation_fixture()
      {expected_schema_validation2, organization2} = schema_validation_fixture(%{@user_attrs | email: "other@email.com"})
      [schema_validation] = Validations.list_schema_validations(organization)
      [schema_validation2] = Validations.list_schema_validations(organization2)

      assert  schema_validation.id == expected_schema_validation.id
      assert  schema_validation2.id == expected_schema_validation2.id
    end
  end
end
