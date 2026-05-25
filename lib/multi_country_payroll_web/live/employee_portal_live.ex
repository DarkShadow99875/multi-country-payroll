defmodule MultiCountryPayrollWeb.EmployeePortalLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.{Employees, Payroll, Audit}

  def mount(%{"employee_id" => id}, _session, socket) do
    employee = Employees.get_employee!(id)
    payroll = Payroll.calculate(employee)
    history = Audit.list_logs_for_entity("employee", employee.id)

    {:ok, assign(socket,
      employee: employee,
      payroll: payroll,
      history: history
    )}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-4xl mx-auto">
        <div class="mb-8">
          <h1 class="text-3xl font-bold">Portale Dipendente</h1>
          <p class="text-zinc-400">Benvenuto, <%= @employee.full_name %></p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <!-- Situazione Attuale -->
          <div class="bg-zinc-900 rounded-2xl p-8">
            <h2 class="text-xl font-semibold mb-6">La tua situazione attuale</h2>

            <div class="space-y-4">
              <div class="flex justify-between">
                <span class="text-zinc-400">Stipendio Lordo Mensile</span>
                <span class="font-mono text-lg"><%= @payroll.gross %> €</span>
              </div>
              <div class="flex justify-between">
                <span class="text-zinc-400">Tasse</span>
                <span class="font-mono text-red-400">-<%= @payroll.tax %> €</span>
              </div>
              <div class="flex justify-between">
                <span class="text-zinc-400">Contributi</span>
                <span class="font-mono text-red-400">-<%= @payroll.social_security %> €</span>
              </div>
              <div class="flex justify-between pt-4 border-t border-zinc-700 font-semibold text-lg">
                <span>Netto Mensile</span>
                <span class="font-mono text-emerald-400"><%= @payroll.net %> €</span>
              </div>
            </div>
          </div>

          <!-- Storico Azioni -->
          <div class="bg-zinc-900 rounded-2xl p-8">
            <h2 class="text-xl font-semibold mb-6">Storico</h2>

            <%= if Enum.empty?(@history) do %>
              <p class="text-zinc-400">Nessuna attività registrata.</p>
            <% else %>
              <div class="space-y-4">
                <%= for log <- @history do %>
                  <div class="border-l-4 border-emerald-500 pl-4">
                    <div class="font-medium"><%= log.action %></div>
                    <div class="text-sm text-zinc-400">
                      <%= Calendar.strftime(log.inserted_at, "%d/%m/%Y %H:%M") %>
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>

        <div class="mt-8 text-center">
          <p class="text-sm text-zinc-500">Questa è una vista simulata del portale dipendente.</p>
        </div>
      </div>
    </div>
    """
  end
end
