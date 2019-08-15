defmodule EventValidator.Events.EventSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_schemas" do
    field :name, :string
    field :schema, :map

    timestamps()
  end

  @doc false
  def changeset(event_schema, attrs) do
    event_schema
    |> cast(attrs, [:name, :schema])
    |> validate_required([:name, :schema])
  end
end
