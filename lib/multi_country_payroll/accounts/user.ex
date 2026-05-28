defmodule MultiCountryPayroll.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :role, :string                    # Legacy single role
    field :company_id, :id
    field :password_hash, :string

    # MFA
    field :mfa_enabled, :boolean, default: false
    field :mfa_secret, :string
    field :mfa_method, :string, default: "email"

    # Many-to-many roles
    many_to_many :roles, MultiCountryPayroll.Accounts.Role,
      join_through: "user_roles",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role, :company_id, :password_hash, :mfa_enabled, :mfa_secret, :mfa_method])
    |> validate_required([:email, :role, :company_id])
    |> unique_constraint(:email)
  end
end