defmodule MultiCountryPayrollWeb.DashboardLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.{Companies, Employees}

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

  def handle_event("filter", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("select_employee", %{"employee_id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("generate_payslip", _params, socket) do
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

        <div class="bg-zinc-900 rounded-2xl p-6 mb-6">
          <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div class="md:col-span-2">
              <label class="block text-sm text-zinc-400 mb-1">Search</label>
              <input type="text" name="search" value={@search} phx-change="filter" phx-debounce="300" placeholder="Search..." class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-2" />
            </div>
          </div>
        </div>

        <div class="bg-zinc-900 rounded-2xl p-6">
          <h2 class="font-semibold mb-4">Employees (<%= length(@filtered_employees) %>)</h2>
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="border-b border-zinc-700 text-left text-sm text-zinc-400">
                  <th class="py-3 px-4">Name</th>
                  <th class="py-3 px-4">Gross Salary</th>
                </tr>
              </thead>
              <tbody>
                <%= for employee <- @filtered_employees do %>
                  <tr>
                    <td class="py-3 px-4"><%= employee.full_name %></td>
                    <td class="py-3 px-4 font-mono"><%= employee.salary_gross_monthly %> €</td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end
end