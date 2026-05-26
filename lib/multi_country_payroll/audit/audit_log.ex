defmodule MultiCountryPayroll.Audit.AuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audit_logs" do
    field :action, :string
    field :resource_type, :string
    field :resource_id, :integer
    field :changes, :map
    field :ip_address, :string
    field :user_agent, :string

    belongs_to :user, MultiCountryPayroll.Accounts.User
    belongs_to :company, MultiCountryPayroll.Companies.Company

    timestamps(type: :utc_datetime)
  end

  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:action, :resource_type, :resource_id, :changes, :ip_address, :user_agent, :user_id, :company_id])
    |> validate_required([:action, :resource_type])
  end
end