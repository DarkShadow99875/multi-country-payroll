defmodule MultiCountryPayroll.Payroll do
  @moduledoc """
  Motore di calcolo paghe avanzato con regole realistiche per 10+ paesi.
  """

  alias MultiCountryPayroll.Employees.Employee

  @country_rules %{
    "IT" => %{tax: 0.23, social: 0.0919, employer: 0.30},
    "US" => %{tax: 0.22, social: 0.062, employer: 0.0765},
    "DE" => %{tax: 0.25, social: 0.186, employer: 0.20},
    "NL" => %{tax: 0.37, social: 0.0, employer: 0.0},
    "ES" => %{tax: 0.19, social: 0.0635, employer: 0.30},
    "FR" => %{tax: 0.30, social: 0.22, employer: 0.42},
    "GB" => %{tax: 0.20, social: 0.12, employer: 0.138},
    "CA" => %{tax: 0.25, social: 0.0495, employer: 0.0},
    "AU" => %{tax: 0.30, social: 0.0, employer: 0.0},
    "BR" => %{tax: 0.275, social: 0.075, employer: 0.20}
  }

  def calculate(%Employee{} = employee) do
    rules = Map.get(@country_rules, employee.country, @country_rules["IT"])
    gross = Decimal.to_float(employee.salary_gross_monthly)

    tax = gross * rules.tax
    social = gross * rules.social
    net = gross - tax - social
    employer_cost = gross * rules.employer

    %{
      gross: Float.round(gross, 2),
      tax: Float.round(tax, 2),
      social_security: Float.round(social, 2),
      net: Float.round(net, 2),
      employer_total_cost: Float.round(employer_cost, 2),
      country: employee.country,
      calculated_on: DateTime.utc_now()
    }
  end
end
