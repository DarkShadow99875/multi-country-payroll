defmodule MultiCountryPayroll.Repo.Migrations.CreateAuditLogs do
  use Ecto.Migration

  def change do
    create table(:audit_logs) do
      add :action, :string, null: false
      add :entity_type, :string, null: false
      add :entity_id, :integer
      add :details, :map
      add :performed_by, :string

      timestamps(type: :utc_datetime)
    end

    create index(:audit_logs, [:entity_type, :entity_id])
    create index(:audit_logs, [:action])
  end
end
