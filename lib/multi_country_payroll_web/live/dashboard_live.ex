defmodule MultiCountryPayrollWeb.DashboardLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.{Companies, Employees, Payroll, Accounts}

  def mount(_params, _session, socket) do
    companies = Companies.list_companies()
    selected_company = List.first(companies)
    employees = if selected_company, do: Employees.list_employees(selected_company.id), else: []

    current_user = socket.assigns[:current_user]
    is_platform_admin = current_user && Enum.any?(current_user.roles || [], &(&1.name == "platform_admin"))

    {:ok, assign(socket,
      companies: companies,
      selected_company: selected_company,
      employees: employees,
      filtered_employees: employees,
      search: "",
      country_filter: "",
      employment_type_filter: "",
      status_filter: "active",
      selected_employee: nil,
      payroll_result: nil,
      is_platform_admin: is_platform_admin
    )}
  end

  def handle_event("filter", params, socket) do
    # ... mantieni codice esistente
    {:noreply, socket}
  end

  def handle_event("select_employee", %{"employee_id" => id}, socket) do
    # ... mantieni codice esistente
    {:noreply, socket}
  end

  def handle_event("generate_payslip", _params, socket) do
    # ... mantieni codice esistente
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-4xl font-bold">Multi-Country Payroll</h1>
            <p class="text-zinc-400">Global Payroll Management System</p>
          </div>
          <div class="flex gap-3">
            <%= if @is_platform_admin do %>
              <a href="/compensation" class="px-6 py-2 bg-purple-600 hover:bg-purple-500 rounded-lg font-semibold">
                Platform Settings
              </a>
            <% end %>
            <button phx-click="add_employee" class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-lg font-semibold">
              + New Employee
            </button>
          </div>
        </div>

        <!-- Advanced Filters -->
        <div class="bg-zinc-900 rounded-2xl p-6 mb-6">
          <!-- ... mantieni codice esistente -->
        </div>

        <!-- Employees Table -->
        <div class="bg-zinc-900 rounded-2xl p-6">
          <!-- ... mantieni codice esistente -->
        </div>

        <!-- Payroll Details -->
        <%= if @selected_employee && @payroll_result do %>
          <!-- ... mantieni codice esistente -->
        <% end %>
      </div>
    </div>
    """
  end
end