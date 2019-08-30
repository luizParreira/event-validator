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
      size: "1-10",
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

    def fixture(:event_schema) do
      {:ok, user} = Accounts.create_user(@user_attrs)
      {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)

      {:ok, %Source{id: id}} =
        Projects.create_source(%{@source_attrs | organization_id: organization.id})

      {:ok, event_schema} =
        Events.create_event_schema(%{
          name: "Click Buy",
          source_id: id,
          schema: %{"json" => "schema"}
        })

      event_schema
    end

    def schema_validation_fixture(attrs \\ %{}) do
      event_schema = fixture(:event_schema)

      {:ok, schema_validation} =
        attrs
        |> Enum.into(%{
          @schema_validation_attrs
          | event_schema_id: event_schema.id
        })
        |> Validations.create_schema_validation()

      schema_validation
    end

    test "list_schema_validations/0 returns all schema_validations" do
      schema_validation = schema_validation_fixture()
      assert Validations.list_schema_validations() == [schema_validation]
    end

    test "get_schema_validation!/1 returns the schema_validation with given id" do
      schema_validation = schema_validation_fixture()
      assert Validations.get_schema_validation!(schema_validation.id) == schema_validation
    end

    test "create_schema_validation/1 with valid data creates a schema_validation" do
      assert {:ok, %SchemaValidation{} = schema_validation} = {:ok, schema_validation_fixture()}

      assert schema_validation.event_params == @params
      assert schema_validation.valid == true
    end

    test "create_schema_validation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Validations.create_schema_validation(@invalid_attrs)
    end
  end
end
