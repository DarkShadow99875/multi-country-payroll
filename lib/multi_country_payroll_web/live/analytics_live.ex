defmodule MultiCountryPayrollWeb.AnalyticsLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Employees

  def mount(_params, _session, socket) do
    employees = Employees.list_employees(1)  # Esempio con company_id = 1

    {:ok, assign(socket, employees: employees)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-7xl mx-auto">
        <h1 class="text-4xl font-bold mb-8">Analytics Dashboard</h1>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="bg-zinc-900 rounded-2xl p-6">
            <div class="text-sm text-zinc-400">Total Employees</div>
            <div class="text-4xl font-bold mt-2"><%= length(@employees) %></div>
          </div>
          <div class="bg-zinc-900 rounded-2xl p-6">
            <div class="text-sm text-zinc-400">Total Gross Cost</div>
            <div class="text-4xl font-bold mt-2 text-emerald-400">
              <%= @employees |> Enum.map(& &1.salary_gross_monthly) |> Enum.sum() %> €
            </div>
          </div>
          <div class="bg-zinc-900 rounded-2xl p-6">
            <div class="text-sm text-zinc-400">Countries</div>
            <div class="text-4xl font-bold mt-2">
              <%= @employees |> Enum.map(& &1.country) |> Enum.uniq() |> length() %>
            </div>
          </div>
        </div>

        <div class="bg-zinc-900 rounded-2xl p-8">
          <h2 class="text-2xl font-semibold mb-6">Employees by Country</h2>
          <div class="space-y-4">
            <%= for {country, count} <- @employees |> Enum.group_by(& &1.country) |> Enum.map(fn {k, v} -> {k, length(v)} end) |> Enum.sort_by(fn {_, c} -> -c end) do %>
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-3 h-3 rounded-full bg-emerald-500"></div>
                  <span><%= country %></span>
                </div>
                <div class="font-mono"><%= count %> employees</div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
