defmodule EventValidator.Repo.Migrations.CreateSchemaValidations do
  use Ecto.Migration

  def change do
    create table(:schema_validations) do
      add :valid, :boolean, default: false, null: false
      add :event_schema_id, references(:event_schemas, on_delete: :nothing)
      add :event_params, :map

      timestamps()
    end

    create index(:schema_validations, [:event_schema_id])
  end
end
