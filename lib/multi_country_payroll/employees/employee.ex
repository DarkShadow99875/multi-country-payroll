defmodule MultiCountryPayroll.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :full_name, :string
    field :email, :string
    field :country, :string
    field :job_title, :string
    field :employment_type, :string
    field :salary_gross_monthly, :decimal
    field :status, :string, default: "active"
    field :company_id, :id

    timestamps(type: :utc_datetime)
  end

  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :email, :country, :job_title, :employment_type, :salary_gross_monthly, :status, :company_id])
    |> validate_required([:full_name, :email, :country, :employment_type, :salary_gross_monthly, :company_id])
  end

  def employee_self_changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :email, :job_title])
    |> validate_required([:full_name, :email])
  end
end
