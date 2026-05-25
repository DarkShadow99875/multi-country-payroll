defmodule MultiCountryPayroll.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :role, :string, null: false
      add :company_id, :integer
      add :employee_id, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
