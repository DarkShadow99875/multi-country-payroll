defmodule MultiCountryPayroll.Payroll do
  @moduledoc """
  Questo modulo gestisce il calcolo delle paghe per diversi paesi.
  Ho provato a tenere le regole il più vicine possibile alla realtà.
  """

  alias MultiCountryPayroll.Employees.Employee

  # Regole per paese (semplificate ma realistiche)
  @country_rules %{
    "IT" => %{tax: 0.23, social: 0.0919, employer: 0.30},
    "US" => %{tax: 0.22, social: 0.062, employer: 0.0765},
    "DE" => %{tax: 0.25, social: 0.186, employer: 0.20},
    "NL" => %{tax: 0.37, social: 0.0, employer: 0.0},
    "ES" => %{tax: 0.19, social: 0.0635, employer: 0.30},
    "FR" => %{tax: 0.30, social: 0.22, employer: 0.42}
  }

  def calculate(%Employee{} = employee) do
    rules = Map.get(@country_rules, employee.country, @country_rules["IT"])
    gross = Decimal.to_float(employee.salary_gross_monthly)

    tax_amount = gross * rules.tax
    social_amount = gross * rules.social
    net = gross - tax_amount - social_amount
    employer_cost = gross * rules.employer

    %{
      gross: Float.round(gross, 2),
      tax: Float.round(tax_amount, 2),
      social_security: Float.round(social_amount, 2),
      net: Float.round(net, 2),
      employer_total_cost: Float.round(employer_cost, 2),
      country: employee.country,
      calculated_on: DateTime.utc_now()
    }
  end

  def calculate_annual(employee) do
    monthly = calculate(employee)
    Map.put(monthly, :annual_net, Float.round(monthly.net * 12, 2))
  end
end
