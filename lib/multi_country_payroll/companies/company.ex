defmodule MultiCountryPayroll.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :country, :string
    field :legal_name, :string
    field :tax_id, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :country, :legal_name, :tax_id])
    |> validate_required([:name, :country])
    |> validate_length(:name, min: 2, max: 100)
  end
end
