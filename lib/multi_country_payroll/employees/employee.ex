defmodule MultiCountryPayroll.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :full_name, :string
    field :email, :string
    field :country, :string
    field :job_title, :string
    field :salary_gross_monthly, :decimal
    field :employment_type, :string
    field :start_date, :date
    field :status, :string, default: "active"

    belongs_to :company, MultiCountryPayroll.Companies.Company

    timestamps(type: :utc_datetime)
  end

  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :email, :country, :job_title, :salary_gross_monthly, :employment_type, :start_date, :status, :company_id])
    |> validate_required([:full_name, :email, :country, :salary_gross_monthly, :employment_type])
    |> validate_inclusion(:country, ["IT", "US", "DE", "NL", "ES", "FR"])
    |> validate_inclusion(:employment_type, ["full_time", "part_time", "contractor"])
  end
end
