defmodule MultiCountryPayroll.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string
    field :level, :integer, default: 0

    belongs_to :parent, __MODULE__
    has_many :children, __MODULE__, foreign_key: :parent_id

    many_to_many :users, MultiCountryPayroll.Accounts.User, join_through: "user_roles"

    timestamps(type: :utc_datetime)
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description, :parent_id, :level])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end