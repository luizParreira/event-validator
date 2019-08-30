defmodule EventValidator.Events.EventSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventValidator.Projects.Source

  schema "event_schemas" do
    field :name, :string
    field :schema, :map
    belongs_to :source, Source, foreign_key: :source_id

    timestamps()
  end

  @doc false
  def changeset(event_schema, attrs) do
    event_schema
    |> cast(attrs, [:name, :schema, :source_id])
    |> validate_required([:name, :schema, :source_id])
    |> foreign_key_constraint(:source_id)
  end
end
