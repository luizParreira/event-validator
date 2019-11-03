defmodule EventValidator.ReportsTest do
  use EventValidator.DataCase

  alias EventValidator.{Projects, Accounts, Events, Validations}
  alias Projects.Source

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
  @schema %{
    "type" => "object",
    "required" => ["event", "properties"],
    "properties" => %{
      "event" => %{
        "type" => "string"
      },
      "properties" => %{
        "type" => "object",
        "properties" => %{
          "anonymousId" => %{"type" => "number"},
          "source" => %{"type" => "string"}
        },
        "required" => [
          "anonymousId",
          "source"
        ]
      }
    }
  }
  @params %{
    "anonymousId" => "other-anynonus-id",
    "timestamp" => "2017-04-28T20:51:55.463",
    "type" => "track",
    "userId" => 10,
    "event" => "Click Buy",
    "properties" => %{
      "userId" => 10,
      "anonymousId" => "an-anonymous-Id",
      "productId" => "a-product-id",
      "productType" => "a-type",
      "price" => 100
    }
  }

  @schema_validation_attrs_a %{
    valid: false,
    event_schema_id: nil,
    event_params: %{@params | "event" => "Click Buy A"}
  }

  @schema_validation_attrs_b %{
    valid: false,
    event_schema_id: nil,
    event_params: %{@params | "event" => "Click Buy B"}
  }

  def schema_validation_fixture(user_attrs \\ @user_attrs) do
    {:ok, user} = Accounts.create_user(user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)

    {:ok, %Source{id: id} = source} =
      Projects.create_source(%{@source_attrs | organization_id: organization.id})

    {:ok, _event_schema} =
      Events.create_event_schema(%{
        name: "Click Buy A",
        source_id: id,
        schema: %{},
        confirmed: true
      })

    {:ok, event_schema_a} =
      Events.create_event_schema(%{
        name: "Click Buy A",
        source_id: id,
        schema: @schema,
        confirmed: true
      })

    Validations.create_schema_validation(%{
      @schema_validation_attrs_a
      | event_schema_id: event_schema_a.id
    })

    Validations.create_schema_validation(%{
      @schema_validation_attrs_a
      | event_schema_id: event_schema_a.id
    })

    Validations.create_schema_validation(%{
      @schema_validation_attrs_a
      | event_schema_id: event_schema_a.id
    })

    {:ok, _event_schema_b} =
      Events.create_event_schema(%{
        name: "Click Buy B",
        source_id: id,
        schema: %{},
        confirmed: true
      })

    {:ok, event_schema_b} =
      Events.create_event_schema(%{
        name: "Click Buy B",
        source_id: id,
        schema: @schema,
        confirmed: true
      })

    Validations.create_schema_validation(%{
      @schema_validation_attrs_b
      | event_schema_id: event_schema_b.id
    })

    Validations.create_schema_validation(%{
      @schema_validation_attrs_b
      | event_schema_id: event_schema_b.id
    })

    {organization, source, event_schema_a, event_schema_b}
  end

  test "event_validation_report/1 returns the report structure for a given organization" do
    {organization, source, event_schema_a, event_schema_b} = schema_validation_fixture()

    assert EventValidator.Reports.event_validation_report(organization) == [
             %EventValidator.Reports.Error{
               event_schema_id: event_schema_a.id,
               source_id: source.id,
               error_count: 3,
               error_message: "Type mismatch. Expected Number but got String.",
               event: "Click Buy A",
               path: "#/properties/anonymousId"
             },
             %EventValidator.Reports.Error{
               event_schema_id: event_schema_a.id,
               source_id: source.id,
               error_count: 3,
               error_message: "Required property source was not present.",
               event: "Click Buy A",
               path: "#/properties"
             },
             %EventValidator.Reports.Error{
               event_schema_id: event_schema_b.id,
               source_id: source.id,
               error_count: 2,
               error_message: "Type mismatch. Expected Number but got String.",
               event: "Click Buy B",
               path: "#/properties/anonymousId"
             },
             %EventValidator.Reports.Error{
               event_schema_id: event_schema_b.id,
               source_id: source.id,
               error_count: 2,
               error_message: "Required property source was not present.",
               event: "Click Buy B",
               path: "#/properties"
             }
           ]
  end
end
