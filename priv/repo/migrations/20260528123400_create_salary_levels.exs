defmodule MultiCountryPayroll.Repo.Migrations.CreateSalaryLevels do
  use Ecto.Migration

  def change do
    create table(:salary_levels) do
      add :country, :string, null: false
      add :job_title, :string, null: false
      add :level, :string                    # Junior, Mid, Senior, Lead, etc.
      add :min_salary, :decimal, precision: 12, scale: 2
      add :max_salary, :decimal, precision: 12, scale: 2
      add :currency, :string, default: "EUR"
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:salary_levels, [:country, :job_title])
    create unique_index(:salary_levels, [:country, :job_title, :level])
  end
end