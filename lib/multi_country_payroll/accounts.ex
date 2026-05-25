defmodule MultiCountryPayroll.Accounts do
  @moduledoc """
  Mock di autenticazione stile Active Directory.
  In un ambiente reale qui ci sarebbe LDAP o Azure AD.
  """

  import Ecto.Query, warn: false
  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Accounts.User

  @mock_password "password123"

  def authenticate(email, password) do
    with %User{} = user <- get_user_by_email(email),
         true <- password == @mock_password do
      {:ok, user}
    else
      _ -> {:error, :invalid_credentials}
    end
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user!(id), do: Repo.get!(User, id)

  # Seed users (chiamato da seeds.exs)
  def create_mock_users do
    # Admin di Acme
    Repo.insert!(%User{email: "admin@acme.it", role: "company_admin", company_id: 1})
    # Dipendente
    Repo.insert!(%User{email: "marco.rossi@acme.it", role: "employee", employee_id: 1})
    Repo.insert!(%User{email: "john.smith@technova.com", role: "employee", employee_id: 3})
  end
end
