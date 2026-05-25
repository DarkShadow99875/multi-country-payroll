defmodule MultiCountryPayrollWeb.RoleManagementLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Accounts

  def mount(_params, _session, socket) do
    # Simuliamo utenti da Active Directory
    users = [
      %{id: 1, email: "admin@acme.it", role: "company_admin", source: "Active Directory"},
      %{id: 2, email: "marco.rossi@acme.it", role: "employee", source: "Active Directory"},
      %{id: 3, email: "john.smith@technova.com", role: "employee", source: "Active Directory"}
    ]

    {:ok, assign(socket, users: users, selected_user: nil)}
  end

  def handle_event("select_user", %{"user_id" => id}, socket) do
    user = Enum.find(socket.assigns.users, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, selected_user: user)}
  end

  def handle_event("change_role", %{"role" => new_role}, socket) do
    if socket.assigns.selected_user do
      # Simuliamo aggiornamento ruolo (in un sistema reale andrebbe su AD)
      updated_users =
        Enum.map(socket.assigns.users, fn u ->
          if u.id == socket.assigns.selected_user.id, do: %{u | role: new_role}, else: u
        end)

      {:noreply, assign(socket, users: updated_users, selected_user: %{socket.assigns.selected_user | role: new_role})}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-zinc-950 text-white p-8">
      <div class="max-w-5xl mx-auto">
        <div class="mb-8">
          <h1 class="text-3xl font-bold">Gestione Ruoli (Mock Active Directory)</h1>
          <p class="text-zinc-400">Simulazione di sincronizzazione ruoli da Azure AD / Active Directory</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Lista Utenti -->
          <div class="lg:col-span-2 bg-zinc-900 rounded-2xl p-6">
            <h2 class="font-semibold mb-4">Utenti sincronizzati da AD</h2>
            <div class="space-y-3">
              <%= for user <- @users do %>
                <div phx-click="select_user" phx-value-user_id={user.id}
                     class={"px-4 py-3 rounded-xl cursor-pointer flex justify-between items-center " <> if @selected_user && @selected_user.id == user.id, do: "bg-emerald-600/20 border border-emerald-500", else: "hover:bg-zinc-800"}>
                  <div>
                    <div class="font-medium"><%= user.email %></div>
                    <div class="text-sm text-zinc-400"><%= user.source %></div>
                  </div>
                  <div class="px-3 py-1 text-xs rounded-full <%= if user.role == "company_admin", do: "bg-purple-600", else: "bg-zinc-700" %>">
                    <%= user.role %>
                  </div>
                </div>
              <% end %>
            </div>
          </div>

          <!-- Dettaglio e Modifica Ruolo -->
          <div class="bg-zinc-900 rounded-2xl p-6">
            <%= if @selected_user do %>
              <h3 class="font-semibold mb-4">Modifica Ruolo</h3>
              <div class="mb-4">
                <div class="text-sm text-zinc-400">Utente</div>
                <div class="font-medium"><%= @selected_user.email %></div>
              </div>

              <div class="mb-6">
                <label class="block text-sm text-zinc-400 mb-2">Ruolo attuale</label>
                <div class="px-4 py-2 bg-zinc-800 rounded-xl"><%= @selected_user.role %></div>
              </div>

              <div>
                <label class="block text-sm text-zinc-400 mb-2">Cambia ruolo</label>
                <div class="flex flex-col gap-2">
                  <button phx-click="change_role" phx-value-role="company_admin"
                          class="px-4 py-2 bg-purple-600 hover:bg-purple-500 rounded-xl text-left">Company Admin</button>
                  <button phx-click="change_role" phx-value-role="employee"
                          class="px-4 py-2 bg-zinc-700 hover:bg-zinc-600 rounded-xl text-left">Employee</button>
                  <button phx-click="change_role" phx-value-role="hr_manager"
                          class="px-4 py-2 bg-zinc-700 hover:bg-zinc-600 rounded-xl text-left">HR Manager</button>
                </div>
              </div>

              <div class="mt-6 text-xs text-zinc-500">
                In un sistema reale questa modifica verrebbe sincronizzata con Azure AD.
              </div>
            <% else %>
              <div class="text-center py-12 text-zinc-400">
                Seleziona un utente per modificare il ruolo
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
