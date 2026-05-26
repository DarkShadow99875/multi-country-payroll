defmodule MultiCountryPayroll.EmployeesTest do
  use MultiCountryPayroll.DataCase

  alias MultiCountryPayroll.Employees
  alias MultiCountryPayroll.Employees.Employee

  import MultiCountryPayroll.EmployeesFixtures

  describe "list_employees/1" do
    test "returns all employees for a company" do
      company = company_fixture()
      employee = employee_fixture(company_id: company.id)

      assert Employees.list_employees(company.id) == [employee]
    end
  end

  describe "get_employee!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Employees.get_employee!(0)
      end
    end
  end

  describe "create_employee/1" do
    test "creates employee with valid data" do
      company = company_fixture()

      attrs = %{
        full_name: "Mario Rossi",
        email: "mario.rossi@example.com",
        country: "IT",
        employment_type: "full_time",
        salary_gross_monthly: Decimal.new("3500.00"),
        company_id: company.id
      }

      assert {:ok, %Employee{} = employee} = Employees.create_employee(attrs)
      assert employee.full_name == "Mario Rossi"
      assert employee.email == "mario.rossi@example.com"
    end

    test "returns error with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(%{})
    end
  end

  describe "update_employee/2" do
    test "updates employee with valid data" do
      company = company_fixture()
      employee = employee_fixture(company_id: company.id)

      update_attrs = %{full_name: "Updated Name"}

      assert {:ok, %Employee{} = updated} = Employees.update_employee(employee, update_attrs)
      assert updated.full_name == "Updated Name"
    end
  end
end