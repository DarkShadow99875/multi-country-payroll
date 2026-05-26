defmodule MultiCountryPayroll.EmployeesFixtures do
  alias MultiCountryPayroll.Companies
  alias MultiCountryPayroll.Employees

  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "Test Company",
        country: "IT",
        tax_id: "IT12345678901"
      })
      |> Companies.create_company()

    company
  end

  def employee_fixture(attrs \\ %{}) do
    company = company_fixture()

    {:ok, employee} =
      attrs
      |> Enum.into(%{
        full_name: "Test Employee",
        email: "test@example.com",
        country: "IT",
        employment_type: "full_time",
        salary_gross_monthly: Decimal.new("3000.00"),
        company_id: company.id
      })
      |> Employees.create_employee()

    employee
  end
end