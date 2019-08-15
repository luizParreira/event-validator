defmodule EventValidator.Repo.Migrations.CreateEventSchemas do
  use Ecto.Migration

  def change do
    create table(:event_schemas) do
      add :name, :string
      add :schema, :map

      timestamps()
    end

  end
end
