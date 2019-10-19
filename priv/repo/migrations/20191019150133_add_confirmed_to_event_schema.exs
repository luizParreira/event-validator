defmodule EventValidator.Repo.Migrations.AddConfirmedToEventSchema do
  use Ecto.Migration

  def change do
    alter table(:event_schemas) do
      add :confirmed, :boolean, default: false
    end
  end
end
