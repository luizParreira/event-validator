defmodule EventValidator.Repo.Migrations.AddSourceIdToEventSchema do
  use Ecto.Migration

  def change do
    alter table("event_schemas") do
      add :source_id, references(:sources, on_delete: :nothing)
    end

    create index(:event_schemas, [:source_id])
  end
end
