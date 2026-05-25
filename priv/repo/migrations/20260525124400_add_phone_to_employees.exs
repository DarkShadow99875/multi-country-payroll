defmodule MultiCountryPayroll.Repo.Migrations.AddPhoneToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add :phone, :string
    end
  end
end
