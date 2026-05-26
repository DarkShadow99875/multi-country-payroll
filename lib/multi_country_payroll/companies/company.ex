defmodule MultiCountryPayroll.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :country, :string
    field :tax_id, :string
    field :address, :string
    field :currency, :string, default: "EUR"

    has_many :employees, MultiCountryPayroll.Employees.Employee

    timestamps(type: :utc_datetime)
  end

  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :country, :tax_id, :address, :currency])
    |> validate_required([:name, :country])
    |> unique_constraint(:tax_id)
  end
end