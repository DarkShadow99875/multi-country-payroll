defmodule MultiCountryPayrollWeb.LoginLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Accounts

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error: nil)}
  end

  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:info, "Accesso effettuato")
          |> assign(:current_user, user)
          |> push_navigate(to: if(user.role == "company_admin", do: "/", else: "/employee-portal?employee_id=#{user.employee_id}"))

        {:noreply, socket}

      {:error, _} ->
        {:noreply, assign(socket, error: "Email o password errati")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-zinc-950">
      <div class="w-full max-w-md">
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold text-white">Multi-Country Payroll</h1>
          <p class="text-zinc-400 mt-2">Accesso aziendale (Mock Active Directory)</p>
        </div>

        <div class="bg-zinc-900 rounded-2xl p-8">
          <form phx-submit="login" class="space-y-6">
            <div>
              <label class="block text-sm font-medium text-zinc-300 mb-2">Email aziendale</label>
              <input type="email" name="email" value="admin@acme.it" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3 text-white" required />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-300 mb-2">Password</label>
              <input type="password" name="password" value="password123" class="w-full bg-zinc-800 border border-zinc-700 rounded-xl px-4 py-3 text-white" required />
            </div>

            <%= if @error do %>
              <div class="text-red-400 text-sm">@error</div>
            <% end %>

            <button type="submit" class="w-full py-3 bg-emerald-600 hover:bg-emerald-500 rounded-xl font-semibold">
              Accedi
            </button>
          </form>

          <div class="mt-6 text-xs text-zinc-500 text-center">
            Credenziali demo:<br>
            admin@acme.it / password123 (Admin)<br>
            marco.rossi@acme.it / password123 (Dipendente)
          </div>
        </div>
      </div>
    </div>
    """
  end
end
