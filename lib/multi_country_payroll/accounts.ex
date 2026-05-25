defmodule MultiCountryPayroll.Accounts do
  @moduledoc """
  Context per l'autenticazione e la gestione utenti.
  """

  import Ecto.Query, warn: false
  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Accounts.User

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_mock_users do
    Repo.insert!(%User{
      email: "admin@acme.it",
      role: "company_admin",
      company_id: 1
    })

    Repo.insert!(%User{
      email: "marco.rossi@acme.it",
      role: "employee",
      company_id: 1
    })

    Repo.insert!(%User{
      email: "john.smith@technova.com",
      role: "employee",
      company_id: 2
    })
  end
end
