defmodule MultiCountryPayroll.Repo.Migrations.CreateRolesAndHierarchy do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :description, :text
      add :parent_id, references(:roles, on_delete: :nilify_all)
      add :level, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:name])
    create index(:roles, [:parent_id])

    create table(:user_roles, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])
  end
end