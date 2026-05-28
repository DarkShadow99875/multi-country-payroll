defmodule MultiCountryPayroll.Repo.Migrations.AddMfaToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :mfa_enabled, :boolean, default: false, null: false
      add :mfa_secret, :string
      add :mfa_method, :string, default: "email"
    end

    create index(:users, [:mfa_enabled])
  end
end