defmodule MultiCountryPayroll.Audit do
  @moduledoc """
  Gestisce lo storico delle azioni (audit log).
  Utile per compliance e per vedere chi ha fatto cosa.
  """

  import Ecto.Query, warn: false
  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Audit.AuditLog

  def log_action(action, entity_type, entity_id, details \\ %{}, performed_by \\ "system") do
    %AuditLog{}
    |> AuditLog.changeset(%{
      action: action,
      entity_type: entity_type,
      entity_id: entity_id,
      details: details,
      performed_by: performed_by
    })
    |> Repo.insert()
  end

  def list_logs_for_entity(entity_type, entity_id) do
    AuditLog
    |> where([l], l.entity_type == ^entity_type and l.entity_id == ^entity_id)
    |> order_by([l], desc: l.inserted_at)
    |> Repo.all()
  end
end
