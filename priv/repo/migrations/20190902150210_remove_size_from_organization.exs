defmodule EventValidator.Repo.Migrations.RemoveSizeFromOrganization do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      remove :size
    end
  end
end
