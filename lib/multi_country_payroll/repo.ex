defmodule MultiCountryPayroll.Repo do
  use Ecto.Repo,
    otp_app: :multi_country_payroll,
    adapter: Ecto.Adapters.Postgres
end