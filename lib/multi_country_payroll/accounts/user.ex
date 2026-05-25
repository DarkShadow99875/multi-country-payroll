defmodule MultiCountryPayroll.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :role, :string
    field :company_id, :id
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role, :company_id, :password_hash])
    |> validate_required([:email, :role, :company_id])
    |> unique_constraint(:email)
  end
end
