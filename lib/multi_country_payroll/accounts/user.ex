defmodule MultiCountryPayroll.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :role, :string
    field :company_id, :integer
    field :employee_id, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role, :company_id, :employee_id])
    |> validate_required([:email, :role])
  end
end
