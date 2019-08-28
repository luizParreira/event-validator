defmodule EventValidator.Projects.SourceToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventValidator.Projects.Source

  schema "source_tokens" do
    field :token, :string
    belongs_to :source, Source, foreign_key: :source_id

    timestamps()
  end

  @doc false
  def changeset(source_token, attrs) do
    source_token
    |> cast(attrs, [:token, :source_id])
    |> validate_required([:token, :source_id])
    |> foreign_key_constraint(:source_id)
  end
end
