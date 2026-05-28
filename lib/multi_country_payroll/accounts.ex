defmodule MultiCountryPayroll.Accounts do
  @moduledoc """
  Context per l'autenticazione, MFA e gestione ruoli gerarchici.
  """

  import Ecto.Query, warn: false
  alias MultiCountryPayroll.Repo
  alias MultiCountryPayroll.Accounts.{User, Role}

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
      |> Repo.preload(:roles)
  end

  def get_user!(id) do
    Repo.get!(User, id)
      |> Repo.preload(:roles)
  end

  def authenticate(email, _password) do
    case get_user_by_email(email) do
      nil -> {:error, :invalid_credentials}
      user -> {:ok, user}
    end
  end

  def update_user_mfa(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # === ROLE MANAGEMENT ===

  def list_roles do
    Repo.all(Role)
      |> Repo.preload(:children)
  end

  def get_role!(id) do
    Repo.get!(Role, id)
      |> Repo.preload([:parent, :children])
  end

  def create_role(attrs) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  def assign_role_to_user(user, role) do
    user
    |> Repo.preload(:roles)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, [role | user.roles])
    |> Repo.update()
  end

  def create_mock_users do
    # ... (mantieni la funzione esistente)
  end
end