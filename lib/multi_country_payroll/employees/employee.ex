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

    belongs_to :company, MultiCountryPayroll.Companies.Company

    timestamps(type: :utc_datetime)
  end

  @required_fields [:full_name, :email, :country, :employment_type, :salary_gross_monthly, :company_id]
  @optional_fields [:job_title, :status]

  @valid_statuses ["active", "inactive", "terminated"]
  @valid_employment_types ["full_time", "part_time", "contractor", "intern"]

  def changeset(employee, attrs) do
    employee
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/^[\w\-\.]+@[\w\-]+\.[\w\-\.]+$/, message: "must be a valid email address")
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:employment_type, @valid_employment_types)
    |> validate_number(:salary_gross_monthly, greater_than: 0)
    |> unique_constraint(:email)
  end

  def employee_self_changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :email, :job_title])
    |> validate_required([:full_name, :email])
    |> validate_format(:email, ~r/^[\w\-\.]+@[\w\-]+\.[\w\-\.]+$/, message: "must be a valid email address")
  end
end