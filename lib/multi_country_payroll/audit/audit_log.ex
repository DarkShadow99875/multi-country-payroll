defmodule MultiCountryPayroll.Audit.AuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audit_logs" do
    field :action, :string
    field :entity_type, :string
    field :entity_id, :integer
    field :details, :map
    field :performed_by, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :entity_type, :entity_id, :details, :performed_by])
    |> validate_required([:action, :entity_type])
  end
end
