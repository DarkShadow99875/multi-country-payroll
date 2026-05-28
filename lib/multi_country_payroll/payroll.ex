defmodule MultiCountryPayroll.Payroll do
  @moduledoc """
  Modulo per il calcolo delle paghe e la gestione dei livelli retributivi.
  """

  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Payroll.SalaryLevel

  def calculate(employee) do
    gross = Decimal.to_float(employee.salary_gross_monthly)

    tax_rate =
      case employee.country do
        "IT" -> 0.23
        "US" -> 0.22
        "DE" -> 0.25
        "FR" -> 0.30
        "UK" -> 0.20
        _ -> 0.23
      end

    tax = gross * tax_rate
    social = gross * 0.09
    net = gross - tax - social

    %{
      gross: gross,
      tax: Float.round(tax, 2),
      social_security: Float.round(social, 2),
      net: Float.round(net, 2),
      country: employee.country
    }
  end

  # === SALARY LEVELS ===

  def list_salary_levels do
    Repo.all(SalaryLevel)
  end

  def get_salary_level(country, job_title, level) do
    Repo.get_by(SalaryLevel, country: country, job_title: job_title, level: level)
  end

  def get_salary_level_by_id(id) do
    Repo.get!(SalaryLevel, id)
  end

  def create_salary_level(attrs) do
    %SalaryLevel{}
    |> SalaryLevel.changeset(attrs)
    |> Repo.insert()
  end

  def update_salary_level(%SalaryLevel{} = level, attrs) do
    level
    |> SalaryLevel.changeset(attrs)
    |> Repo.update()
  end

  def suggest_salary(country, job_title, level) do
    case get_salary_level(country, job_title, level) do
      nil -> %{min: 2500, max: 4500, currency: "EUR"}
      band -> %{min: band.min_salary, max: band.max_salary, currency: band.currency}
    end
  end
end