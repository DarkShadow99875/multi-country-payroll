defmodule MultiCountryPayroll.PayrollTest do
  use ExUnit.Case, async: true

  alias MultiCountryPayroll.Payroll
  alias MultiCountryPayroll.Employees.Employee

  describe "calculate/1" do
    test "calculates payroll correctly for Italy" do
      employee = %Employee{
        salary_gross_monthly: Decimal.new("4000"),
        country: "IT"
      }

      result = Payroll.calculate(employee)

      assert result.gross == 4000.0
      assert result.tax > 0
      assert result.net < result.gross
      assert result.country == "IT"
    end

    test "uses default tax rate for unknown country" do
      employee = %Employee{
        salary_gross_monthly: Decimal.new("3000"),
        country: "XX"
      }

      result = Payroll.calculate(employee)

      assert result.gross == 3000.0
      assert result.tax == 690.0  # 23% default
    end
  end
end