defmodule MultiCountryPayrollWeb.DashboardLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.{Companies, Employees, Payroll, Audit}

  def mount(_params, _session, socket) do
    companies = Companies.list_companies()
    selected_company = List.first(companies)
    employees = if selected_company, do: Employees.list_employees(selected_company.id), else: []

    {:ok, assign(socket,
      companies: companies,
      selected_company: selected_company,
      employees: employees,
      selected_employee: nil,
      payroll_result: nil,
      editing_employee: nil,
      show_delete_modal: false,
      employee_to_delete: nil
    )}
  end

  def handle_event("select_company", %{"company_id" => id}, socket) do
    company = Companies.get_company!(String.to_integer(id))
    employees = Employees.list_employees(company.id)
    {:noreply, assign(socket, selected_company: company, employees: employees, selected_employee: nil, payroll_result: nil)}
  end

  def handle_event("select_employee", %{"employee_id" => id}, socket) do
    employee = Employees.get_employee!(String.to_integer(id))
    payroll = Payroll.calculate(employee)
    {:noreply, assign(socket, selected_employee: employee, payroll_result: payroll)}
  end

  def handle_event("edit_employee", %{"employee_id" => id}, socket) do
    employee = Employees.get_employee!(String.to_integer(id))
    {:noreply, assign(socket, editing_employee: employee)}
  end

  def handle_event("delete_employee", %{"employee_id" => id}, socket) do
    employee = Employees.get_employee!(String.to_integer(id))
    {:noreply, assign(socket, show_delete_modal: true, employee_to_delete: employee)}
  end

  def handle_event("confirm_delete", _params, socket) do
    if socket.assigns.employee_to_delete do
      Employees.delete_employee(socket.assigns.employee_to_delete)
      Audit.log_action("employee_deleted", "employee", socket.assigns.employee_to_delete.id, %{}, "admin")

      employees = Employees.list_employees(socket.assigns.selected_company.id)
      {:noreply, assign(socket,
        employees: employees,
        show_delete_modal: false,
        employee_to_delete: nil,
        selected_employee: nil
      )}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cancel_delete", _params, socket) do
    {:noreply, assign(socket, show_delete_modal: false, employee_to_delete: nil)}
  end

  def handle_event("add_employee", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/employees/new")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-4xl font-bold">Multi-Country Payroll</h1>
            <p class="text-zinc-400">Gestionale HR & Payroll Internazionale</p>
          </div>
          <button phx-click="add_employee" class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-lg font-semibold flex items-center gap-2">
            <span>+</span> <span>Nuovo Dipendente</span>
          </button>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Companies -->
          <div>
            <div class="bg-zinc-900 rounded-2xl p-6">
              <h2 class="font-semibold mb-4">Aziende</h2>
              <div class="space-y-2">
                <%= for company <- @companies do %>
                  <div phx-click="select_company" phx-value-company_id={company.id}
                       class={"px-4 py-3 rounded-xl cursor-pointer " <> if @selected_company && @selected_company.id == company.id, do: "bg-emerald-600/30 border border-emerald-500", else: "hover:bg-zinc-800"}>
                    <div class="font-medium"><%= company.name %></div>
                    <div class="text-sm text-zinc-400"><%= company.country %></div>
                  </div>
                <% end %>
              </div>
            </div>
          </div>

          <!-- Employees List with CRUD -->
          <div class="lg:col-span-2">
            <div class="bg-zinc-900 rounded-2xl p-6">
              <div class="flex justify-between mb-4">
                <h2 class="font-semibold">Dipendenti (<%= length(@employees) %>)</h2>
              </div>

              <%= if Enum.empty?(@employees) do %>
                <p class="text-zinc-400 py-8 text-center">Nessun dipendente in questa azienda</p>
              <% else %>
                <div class="space-y-3">
                  <%= for employee <- @employees do %>
                    <div class="flex items-center justify-between bg-zinc-800/50 px-4 py-3 rounded-xl hover:bg-zinc-800 transition">
                      <div phx-click="select_employee" phx-value-employee_id={employee.id} class="flex-1 cursor-pointer">
                        <div class="font-medium"><%= employee.full_name %></div>
                        <div class="text-sm text-zinc-400"><%= employee.job_title || "N/A" %> • <%= employee.country %></div>
                      </div>

                      <div class="flex gap-2">
                        <button phx-click="edit_employee" phx-value-employee_id={employee.id}
                                class="px-3 py-1 text-xs bg-zinc-700 hover:bg-zinc-600 rounded">Modifica</button>
                        <button phx-click="delete_employee" phx-value-employee_id={employee.id}
                                class="px-3 py-1 text-xs bg-red-600/80 hover:bg-red-600 rounded">Elimina</button>
                      </div>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>

          <!-- Payroll Details -->
          <div class="lg:col-span-3">
            <%= if @selected_employee do %>
              <div class="bg-zinc-900 rounded-2xl p-8">
                <h2 class="font-semibold mb-4">Dettaglio Payroll - <%= @selected_employee.full_name %></h2>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                  <div><span class="text-zinc-400">Lordo</span><br><span class="font-mono text-lg"><%= @payroll_result.gross %> €</span></div>
                  <div><span class="text-zinc-400">Tasse</span><br><span class="font-mono text-red-400"><%= @payroll_result.tax %> €</span></div>
                  <div><span class="text-zinc-400">Contributi</span><br><span class="font-mono text-red-400"><%= @payroll_result.social_security %> €</span></div>
                  <div><span class="text-zinc-400">Netto</span><br><span class="font-mono text-emerald-400 text-lg"><%= @payroll_result.net %> €</span></div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>

      <!-- Delete Confirmation Modal -->
      <%= if @show_delete_modal do %>
        <div class="fixed inset-0 bg-black/70 flex items-center justify-center z-50">
          <div class="bg-zinc-900 rounded-2xl p-8 max-w-md w-full">
            <h3 class="text-xl font-semibold mb-4">Conferma eliminazione</h3>
            <p class="text-zinc-400 mb-6">Sei sicuro di voler eliminare <strong><%= @employee_to_delete.full_name %></strong>?</p>
            <div class="flex gap-4">
              <button phx-click="cancel_delete" class="flex-1 py-2.5 bg-zinc-700 hover:bg-zinc-600 rounded-xl">Annulla</button>
              <button phx-click="confirm_delete" class="flex-1 py-2.5 bg-red-600 hover:bg-red-500 rounded-xl font-semibold">Elimina definitivamente</button>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
