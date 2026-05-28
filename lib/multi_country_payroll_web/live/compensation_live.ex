defmodule MultiCountryPayrollWeb.CompensationLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Payroll
  alias MultiCountryPayroll.Payroll.SalaryLevel

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      salary_levels: Payroll.list_salary_levels(),
      show_form: false,
      editing: nil,
      form: to_form(SalaryLevel.changeset(%SalaryLevel{}, %{}))
    )}
  end

  def handle_event("new", _params, socket) do
    {:noreply, assign(socket, show_form: true, editing: nil, form: to_form(SalaryLevel.changeset(%SalaryLevel{}, %{})))}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    level = Payroll.get_salary_level_by_id(String.to_integer(id))
    {:noreply, assign(socket,
      show_form: true,
      editing: level,
      form: to_form(SalaryLevel.changeset(level, %{}))
    )}
  end

  def handle_event("save", %{"salary_level" => params}, socket) do
    result =
      if socket.assigns.editing do
        Payroll.update_salary_level(socket.assigns.editing, params)
      else
        Payroll.create_salary_level(params)
      end

    case result do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign(salary_levels: Payroll.list_salary_levels(), show_form: false, editing: nil)
         |> put_flash(:info, "Livello retributivo salvato con successo")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, show_form: false, editing: nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-4xl font-bold">Compensation Management</h1>
            <p class="text-zinc-400">Gestione livelli retributivi per Paese e Ambito Lavorativo</p>
          </div>
          <button phx-click="new" class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-lg font-semibold">
            + Nuovo Livello
          </button>
        </div>

        <%= if @show_form do %>
          <div class="bg-zinc-900 rounded-2xl p-8 mb-8">
            <h2 class="text-2xl font-semibold mb-6"><%= if @editing, do: "Modifica", else: "Nuovo" %> Livello Retributivo</h2>

            <.form for={@form} phx-submit="save" class="space-y-6">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Paese</label>
                  <input type="text" name="salary_level[country]" value={@form[:country].value} class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3" placeholder="IT, US, DE..." />
                </div>

                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Job Title / Ruolo</label>
                  <input type="text" name="salary_level[job_title]" value={@form[:job_title].value} class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3" placeholder="Software Engineer, HR Manager..." />
                </div>

                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Livello</label>
                  <select name="salary_level[level]" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3">
                    <option value="Junior">Junior</option>
                    <option value="Mid">Mid</option>
                    <option value="Senior">Senior</option>
                    <option value="Lead">Lead</option>
                    <option value="Principal">Principal</option>
                  </select>
                </div>

                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Valuta</label>
                  <input type="text" name="salary_level[currency]" value={@form[:currency].value || "EUR"} class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3" />
                </div>

                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Stipendio Minimo</label>
                  <input type="number" step="0.01" name="salary_level[min_salary]" value={@form[:min_salary].value} class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3" />
                </div>

                <div>
                  <label class="block text-sm text-zinc-400 mb-1">Stipendio Massimo</label>
                  <input type="number" step="0.01" name="salary_level[max_salary]" value={@form[:max_salary].value} class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3" />
                </div>
              </div>

              <div class="flex gap-4 pt-4">
                <button type="submit" class="px-8 py-3 bg-emerald-600 hover:bg-emerald-500 rounded-xl font-semibold">Salva</button>
                <button type="button" phx-click="cancel" class="px-8 py-3 bg-zinc-700 hover:bg-zinc-600 rounded-xl">Annulla</button>
              </div>
            </.form>
          </div>
        <% end %>

        <div class="bg-zinc-900 rounded-2xl p-6">
          <h3 class="font-semibold mb-4">Livelli Retributivi Configurati</h3>

          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="border-b border-zinc-700 text-left text-sm text-zinc-400">
                  <th class="py-3 px-4">Paese</th>
                  <th class="py-3 px-4">Ruolo</th>
                  <th class="py-3 px-4">Livello</th>
                  <th class="py-3 px-4">Range</th>
                  <th class="py-3 px-4 text-right">Azioni</th>
                </tr>
              </thead>
              <tbody>
                <%= for level <- @salary_levels do %>
                  <tr class="border-b border-zinc-800">
                    <td class="py-3 px-4 font-medium"><%= level.country %></td>
                    <td class="py-3 px-4"><%= level.job_title %></td>
                    <td class="py-3 px-4"><span class="px-3 py-1 text-xs bg-zinc-700 rounded-full"><%= level.level %></span></td>
                    <td class="py-3 px-4 font-mono"><%= level.min_salary %> - <%= level.max_salary %> <%= level.currency %></td>
                    <td class="py-3 px-4 text-right">
                      <button phx-click="edit" phx-value-id={level.id} class="px-4 py-1 text-xs bg-zinc-700 hover:bg-zinc-600 rounded mr-2">Modifica</button>
                    </td>
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