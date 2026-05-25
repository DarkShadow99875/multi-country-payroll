defmodule MultiCountryPayroll.Employees do
  import Ecto.Query, warn: false
  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Employees.Employee

  def list_employees(company_id) do
    Employee
    |> where([e], e.company_id == ^company_id)
    |> Repo.all()
  end

  def get_employee!(id), do: Repo.get!(Employee, id)

  def create_employee(attrs) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  # Per il self-service del dipendente
  def update_employee_self(%Employee{} = employee, attrs) do
    employee
    |> Employee.employee_self_changeset(attrs)
    |> Repo.update()
  end

  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  def change_employee(%Employee{} = employee, attrs \\ %{}) do
    Employee.changeset(employee, attrs)
  end
end
