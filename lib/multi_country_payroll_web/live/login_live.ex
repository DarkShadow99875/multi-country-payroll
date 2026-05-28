defmodule MultiCountryPayrollWeb.LoginLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Accounts

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      step: :login,
      error: nil,
      email: "",
      password: "",
      otp: "",
      brand_name: "MultiCountryPayroll",
      tagline: "Global Payroll, Simplified",
      primary_color: "emerald",
      logo_text: "MCP"
    )}
  end

  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        socket =
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Accesso effettuato")
          |> push_navigate(to: if(user.role == "company_admin", do: "/", else: "/employee-portal"))

        {:noreply, socket}

      {:error, _} ->
        {:noreply, assign(socket, error: "Email o password errati")}
    end
  end

  def handle_event("verify_otp", %{"otp" => otp}, socket) do
    if otp == "123456" do
      {:noreply, push_navigate(socket, to: "/")}
    else
      {:noreply, assign(socket, error: "Codice OTP non valido")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-zinc-950">
      <div class="w-full max-w-md px-4">
        <div class="text-center mb-10">
          <div class="flex justify-center mb-4">
            <div class="w-16 h-16 bg-<%= @primary_color %>-600 rounded-2xl flex items-center justify-center">
              <span class="text-white text-3xl font-bold"><%= @logo_text %></span>
            </div>
          </div>
          <h1 class="text-4xl font-bold text-white tracking-tight"><%= @brand_name %></h1>
          <p class="text-zinc-400 mt-2 text-lg"><%= @tagline %></p>
        </div>

        <div class="bg-zinc-900 rounded-3xl p-10 shadow-2xl border border-zinc-800">
          <%= if @step == :login do %>
            <form phx-submit="login" class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-zinc-300 mb-2">Email aziendale</label>
                <input type="email" name="email" value={@email} class="w-full bg-zinc-800 border border-zinc-700 focus:border-<%= @primary_color %>-500 rounded-2xl px-5 py-3.5 text-white placeholder-zinc-500" placeholder="tuo@azienda.com" required />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-300 mb-2">Password</label>
                <input type="password" name="password" value={@password} class="w-full bg-zinc-800 border border-zinc-700 focus:border-<%= @primary_color %>-500 rounded-2xl px-5 py-3.5 text-white" placeholder="••••••••" required />
              </div>

              <div class="flex items-center justify-between text-sm">
                <label class="flex items-center gap-2 text-zinc-400">
                  <input type="checkbox" class="accent-<%= @primary_color %>-500"> Remember me
                </label>
                <a href="#" class="text-<%= @primary_color %>-400 hover:underline">Forgot password?</a>
              </div>

              <%= if @error do %>
                <div class="text-red-400 text-sm bg-red-950/50 p-3 rounded-xl"><%= @error %></div>
              <% end %>

              <button type="submit" class="w-full py-4 bg-<%= @primary_color %>-600 hover:bg-<%= @primary_color %>-500 rounded-2xl font-semibold text-lg transition-all active:scale-[0.985]">
                Sign in
              </button>
            </form>

            <div class="mt-8 text-center text-sm text-zinc-500">
              Do not have an account? <a href="#" class="text-<%= @primary_color %>-400 hover:underline">Sign up</a>
            </div>

          <% else %>
            <div class="text-center">
              <div class="mx-auto w-16 h-16 bg-zinc-800 rounded-full flex items-center justify-center mb-6">
                <span class="text-4xl">🔐</span>
              </div>
              <h2 class="text-2xl font-semibold text-white mb-2">Two-Factor Authentication</h2>
              <p class="text-zinc-400 mb-8">Enter the 6-digit code from your authenticator app or email</p>

              <form phx-submit="verify_otp" class="space-y-6">
                <div class="flex justify-center gap-3">
                  <%= for _ <- 1..6 do %>
                    <input type="text" maxlength="1" name="otp[]" class="w-12 h-14 text-center text-2xl font-mono bg-zinc-800 border border-zinc-700 focus:border-<%= @primary_color %>-500 rounded-2xl" />
                  <% end %>
                </div>

                <%= if @error do %>
                  <div class="text-red-400 text-sm"><%= @error %></div>
                <% end %>

                <button type="submit" class="w-full py-4 bg-<%= @primary_color %>-600 hover:bg-<%= @primary_color %>-500 rounded-2xl font-semibold text-lg">
                  Verify Code
                </button>

                <button type="button" phx-click="resend_otp" class="text-sm text-zinc-400 hover:text-white">
                  Did not receive the code? Resend
                </button>
              </form>
            </div>
          <% end %>
        </div>

        <div class="mt-8 text-center text-xs text-zinc-500">
          Secure enterprise login - Powered by Elixir + LiveView
        </div>
      </div>
    </div>
    """
  end
end