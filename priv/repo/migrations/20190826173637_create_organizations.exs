defmodule EventValidator.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :website, :string
      add :size, :string

      timestamps()
    end
  end
end
