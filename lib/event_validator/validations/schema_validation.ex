defmodule EventValidator.Validations.SchemaValidation do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventValidator.Events.EventSchema

  schema "schema_validations" do
    field :event_params, :map, default: nil
    field :valid, :boolean, default: false
    belongs_to :event_schema, EventSchema, foreign_key: :event_schema_id

    timestamps()
  end

  @doc false
  def changeset(schema_validation, attrs) do
    schema_validation
    |> cast(attrs, [:valid, :event_schema_id, :event_params])
    |> validate_required([:valid, :event_schema_id])
    |> foreign_key_constraint(:event_schema_id)
  end
end
