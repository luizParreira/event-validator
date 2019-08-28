defmodule EventValidator.Repo.Migrations.CreateSourceTokens do
  use Ecto.Migration

  def change do
    create table(:source_tokens) do
      add :token, :string
      add :source_id, references(:sources, on_delete: :nothing)

      timestamps()
    end

    create index(:source_tokens, [:source_id])
  end
end
