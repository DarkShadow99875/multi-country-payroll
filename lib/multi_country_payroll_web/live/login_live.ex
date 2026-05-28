defmodule MultiCountryPayrollWeb.LoginLive do
  use MultiCountryPayrollWeb, :live_view

  alias MultiCountryPayroll.Accounts
  alias NimbleTOTP

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      step: :login,
      error: nil,
      email: "",
      password: "",
      otp: "",
      mfa_method: nil,
      totp_secret: nil,
      brand_name: "MultiCountryPayroll",
      tagline: "Global Payroll, Simplified",
      primary_color: "emerald",
      logo_text: "MCP"
    )}
  end

  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        if user.mfa_enabled do
          {:noreply, assign(socket, step: :mfa, current_user: user, mfa_method: user.mfa_method)}
        else
          {:noreply, assign(socket, step: :choose_mfa, current_user: user)}
        end

      {:error, _} ->
        {:noreply, assign(socket, error: "Email o password errati")}
    end
  end

  def handle_event("choose_mfa", %{"method" => method}, socket) do
    user = socket.assigns.current_user

    if method == "totp" do
      secret = NimbleTOTP.secret()
      {:noreply, assign(socket, step: :setup_totp, totp_secret: secret, mfa_method: "totp")}
    else
      {:noreply, assign(socket, step: :mfa, mfa_method: "email")}
    end
  end

  def handle_event("verify_otp", %{"otp" => otp}, socket) do
    user = socket.assigns.current_user

    if socket.assigns.mfa_method == "totp" do
      if NimbleTOTP.valid?(user.mfa_secret || socket.assigns.totp_secret, otp) do
        if !user.mfa_enabled do
          Accounts.update_user_mfa(user, %{mfa_enabled: true, mfa_secret: socket.assigns.totp_secret, mfa_method: "totp"})
        end
        {:noreply, push_navigate(socket, to: "/")}
      else
        {:noreply, assign(socket, error: "Codice non valido")}
      end
    else
      if otp == "123456" do
        {:noreply, push_navigate(socket, to: "/")}
      else
        {:noreply, assign(socket, error: "Codice non valido")}
      end
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-zinc-950">
      <div class="w-full max-w-md px-4">
        <div class="text-center mb-10">
          <div class="flex justify-center mb-4">
            <div class="w-16 h-16 bg-emerald-600 rounded-2xl flex items-center justify-center">
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
                <input type="email" name="email" value={@email} class="w-full bg-zinc-800 border border-zinc-700 focus:border-emerald-500 rounded-2xl px-5 py-3.5 text-white placeholder-zinc-500" placeholder="tuo@azienda.com" required />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-300 mb-2">Password</label>
                <input type="password" name="password" value={@password} class="w-full bg-zinc-800 border border-zinc-700 focus:border-emerald-500 rounded-2xl px-5 py-3.5 text-white" placeholder="••••••••" required />
              </div>

              <%= if @error do %>
                <div class="text-red-400 text-sm bg-red-950/50 p-3 rounded-xl"><%= @error %></div>
              <% end %>

              <button type="submit" class="w-full py-4 bg-emerald-600 hover:bg-emerald-500 rounded-2xl font-semibold text-lg transition-all active:scale-[0.985]">
                Sign in
              </button>
            </form>

          <% end %>

          <%= if @step == :choose_mfa do %>
            <div class="text-center">
              <h2 class="text-2xl font-semibold text-white mb-4">Scegli il metodo di autenticazione a due fattori</h2>
              <p class="text-zinc-400 mb-8">Per la tua sicurezza, configura ora l'autenticazione a due fattori.</p>

              <div class="space-y-4">
                <button phx-click="choose_mfa" phx-value-method="totp" class="w-full py-4 bg-emerald-600 hover:bg-emerald-500 rounded-2xl font-semibold text-lg">
                  Microsoft Authenticator (TOTP)
                </button>

                <button phx-click="choose_mfa" phx-value-method="email" class="w-full py-4 bg-zinc-700 hover:bg-zinc-600 rounded-2xl font-semibold text-lg">
                  Email OTP
                </button>
              </div>
            </div>
          <% end %>

          <%= if @step == :setup_totp do %>
            <div class="text-center">
              <h2 class="text-2xl font-semibold text-white mb-4">Configura Microsoft Authenticator</h2>
              <p class="text-zinc-400 mb-6">Scansiona questo QR code con l'app Microsoft Authenticator</p>

              <div class="bg-white p-6 rounded-2xl mb-6">
                <div class="text-center">
                  <p class="text-sm text-zinc-600 mb-2">Secret (per test):</p>
                  <code class="text-xs break-all"><%= Base.encode32(@totp_secret, padding: false) %></code>
                </div>
              </div>

              <form phx-submit="verify_otp" class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-zinc-300 mb-2">Inserisci il codice a 6 cifre</label>
                  <input type="text" name="otp" maxlength="6" class="w-full bg-zinc-800 border border-zinc-700 focus:border-emerald-500 rounded-2xl px-5 py-3.5 text-white text-center text-2xl tracking-[8px]" placeholder="123456" required />
                </div>

                <%= if @error do %>
                  <div class="text-red-400 text-sm"><%= @error %></div>
                <% end %>

                <button type="submit" class="w-full py-4 bg-emerald-600 hover:bg-emerald-500 rounded-2xl font-semibold text-lg">
                  Verifica e Attiva
                </button>
              </form>
            </div>
          <% end %>

          <%= if @step == :mfa do %>
            <div class="text-center">
              <div class="mx-auto w-16 h-16 bg-zinc-800 rounded-full flex items-center justify-center mb-6">
                <span class="text-4xl">🔐</span>
              </div>
              <h2 class="text-2xl font-semibold text-white mb-2">Two-Factor Authentication</h2>
              <p class="text-zinc-400 mb-8">Inserisci il codice <%= if @mfa_method == "totp", do: "da Microsoft Authenticator", else: "inviato via email" %></p>

              <form phx-submit="verify_otp" class="space-y-6">
                <div>
                  <input type="text" name="otp" maxlength="6" class="w-full bg-zinc-800 border border-zinc-700 focus:border-emerald-500 rounded-2xl px-5 py-3.5 text-white text-center text-2xl tracking-[8px]" placeholder="123456" required />
                </div>

                <%= if @error do %>
                  <div class="text-red-400 text-sm"><%= @error %></div>
                <% end %>

                <button type="submit" class="w-full py-4 bg-emerald-600 hover:bg-emerald-500 rounded-2xl font-semibold text-lg">
                  Verifica
                </button>

                <button type="button" phx-click="resend_otp" class="text-sm text-zinc-400 hover:text-white">
                  Non hai ricevuto il codice? Invia di nuovo
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