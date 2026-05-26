defmodule MultiCountryPayrollWeb.DashboardLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.{Companies, Employees, Payroll}

  @impl true
  def mount(_params, _session, socket) do
    companies = Companies.list_companies()
    selected_company = List.first(companies)
    employees = if selected_company, do: Employees.list_employees(selected_company.id), else: []

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
      payroll_result: nil
    )}
  end

  @impl true
  def handle_event("filter", params, socket) do
    search = Map.get(params, "search", "")
    country = Map.get(params, "country", "")
    employment_type = Map.get(params, "employment_type", "")
    status = Map.get(params, "status", "active")

    filtered =
      socket.assigns.employees
      |> filter_employees(search, country, employment_type, status)

    {:noreply, assign(socket,
      filtered_employees: filtered,
      search: search,
      country_filter: country,
      employment_type_filter: employment_type,
      status_filter: status
    )}
  end

  @impl true
  def handle_event("select_employee", %{"employee_id" => id}, socket) do
    employee = Employees.get_employee!(String.to_integer(id))
    payroll = Payroll.calculate(employee)
    {:noreply, assign(socket, selected_employee: employee, payroll_result: payroll)}
  end

  defp filter_employees(employees, search, country, employment_type, status) do
    employees
    |> filter_by_search(search)
    |> filter_by_country(country)
    |> filter_by_employment_type(employment_type)
    |> filter_by_status(status)
  end

  defp filter_by_search(employees, ""), do: employees
  defp filter_by_search(employees, search) do
    search = String.downcase(search)
    Enum.filter(employees, fn e ->
      String.contains?(String.downcase(e.full_name), search) or
      String.contains?(String.downcase(e.email || ""), search) or
      String.contains?(String.downcase(e.job_title || ""), search)
    end)
  end

  defp filter_by_country(employees, ""), do: employees
  defp filter_by_country(employees, country) do
    Enum.filter(employees, &(&1.country == country))
  end

  defp filter_by_employment_type(employees, ""), do: employees
  defp filter_by_employment_type(employees, type) do
    Enum.filter(employees, &(&1.employment_type == type))
  end

  defp filter_by_status(employees, "all"), do: employees
  defp filter_by_status(employees, status) do
    Enum.filter(employees, &(&1.status == status))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-4xl font-bold">Multi-Country Payroll</h1>
            <p class="text-zinc-400">Global Payroll Management System</p>
          </div>
          <button phx-click="add_employee" class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-lg font-semibold">
            + New Employee
          </button>
        </div>

        <!-- Advanced Filters -->
        <div class="bg-zinc-900 rounded-2xl p-6 mb-6">
          <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div class="md:col-span-2">
              <label class="block text-sm text-zinc-400 mb-1">Search</label>
              <input type="text" name="search" value={@search} phx-change="filter" phx-debounce="300"
                     placeholder="Search by name, email or job title..." class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-2" />
            </div>
            <div>
              <label class="block text-sm text-zinc-400 mb-1">Country</label>
              <select name="country" phx-change="filter" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-2">
                <option value="">All Countries</option>
                <option value="IT">Italy</option>
                <option value="US">United States</option>
                <option value="DE">Germany</option>
                <option value="NL">Netherlands</option>
                <option value="ES">Spain</option>
                <option value="FR">France</option>
              </select>
            </div>
            <div>
              <label class="block text-sm text-zinc-400 mb-1">Employment Type</label>
              <select name="employment_type" phx-change="filter" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-2">
                <option value="">All Types</option>
                <option value="full_time">Full Time</option>
                <option value="part_time">Part Time</option>
                <option value="contractor">Contractor</option>
              </select>
            </div>
            <div>
              <label class="block text-sm text-zinc-400 mb-1">Status</label>
              <select name="status" phx-change="filter" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-2">
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
                <option value="all">All</option>
              </select>
            </div>
          </div>
        </div>

        <!-- Employees Table -->
        <div class="bg-zinc-900 rounded-2xl p-6">
          <h2 class="font-semibold mb-4">Employees (<%= length(@filtered_employees) %>)</h2>

          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="border-b border-zinc-700 text-left text-sm text-zinc-400">
                  <th class="py-3 px-4">Name</th>
                  <th class="py-3 px-4">Country</th>
                  <th class="py-3 px-4">Job Title</th>
                  <th class="py-3 px-4">Type</th>
                  <th class="py-3 px-4">Gross Salary</th>
                  <th class="py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for employee <- @filtered_employees do %>
                  <tr phx-click="select_employee" phx-value-employee_id={employee.id} class="border-b border-zinc-800 hover:bg-zinc-800 cursor-pointer">
                    <td class="py-3 px-4 font-medium"><%= employee.full_name %></td>
                    <td class="py-3 px-4"><%= employee.country %></td>
                    <td class="py-3 px-4 text-zinc-400"><%= employee.job_title || "-" %></td>
                    <td class="py-3 px-4"><%= employee.employment_type %></td>
                    <td class="py-3 px-4 font-mono"><%= employee.salary_gross_monthly %> €</td>
                    <td class="py-3 px-4 text-right">
                      <button phx-click="edit_employee" phx-value-employee_id={employee.id} class="px-3 py-1 text-xs bg-zinc-700 hover:bg-zinc-600 rounded mr-2">Edit</button>
                      <button phx-click="delete_employee" phx-value-employee_id={employee.id} class="px-3 py-1 text-xs bg-red-600/80 hover:bg-red-600 rounded">Delete</button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Payroll Details -->
        <%= if @selected_employee do %>
          <div class="mt-8 bg-zinc-900 rounded-2xl p-8">
            <h2 class="font-semibold mb-4">Payroll Details - <%= @selected_employee.full_name %></h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div><span class="text-zinc-400">Gross</span><br><span class="font-mono text-lg"><%= @payroll_result.gross %> €</span></div>
              <div><span class="text-zinc-400">Tax</span><br><span class="font-mono text-red-400"><%= @payroll_result.tax %> €</span></div>
              <div><span class="text-zinc-400">Social Security</span><br><span class="font-mono text-red-400"><%= @payroll_result.social_security %> €</span></div>
              <div><span class="text-zinc-400">Net Pay</span><br><span class="font-mono text-emerald-400 text-lg"><%= @payroll_result.net %> €</span></div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end