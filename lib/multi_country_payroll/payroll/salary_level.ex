defmodule MultiCountryPayroll.Payroll.SalaryLevel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "salary_levels" do
    field :country, :string
    field :job_title, :string
    field :level, :string
    field :min_salary, :decimal
    field :max_salary, :decimal
    field :currency, :string, default: "EUR"
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(level, attrs) do
    level
    |> cast(attrs, [:country, :job_title, :level, :min_salary, :max_salary, :currency, :description])
    |> validate_required([:country, :job_title, :level, :min_salary, :max_salary])
    |> validate_number(:min_salary, greater_than_or_equal_to: 0)
    |> validate_number(:max_salary, greater_than: :min_salary)
  end
end