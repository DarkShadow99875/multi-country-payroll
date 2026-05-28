defmodule MultiCountryPayroll.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :role, :string
    field :company_id, :id
    field :password_hash, :string

    # MFA fields
    field :mfa_enabled, :boolean, default: false
    field :mfa_secret, :string
    field :mfa_method, :string, default: "email"

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role, :company_id, :password_hash, :mfa_enabled, :mfa_secret, :mfa_method])
    |> validate_required([:email, :role, :company_id])
    |> unique_constraint(:email)
  end
end