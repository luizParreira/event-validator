defmodule EventValidator.Repo.Migrations.CreateUsersOrganizations do
  use Ecto.Migration

  def change do
    create table(:users_organizations) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)

      timestamps()
    end

    create index(:users_organizations, [:user_id])
    create index(:users_organizations, [:organization_id])
  end
end
