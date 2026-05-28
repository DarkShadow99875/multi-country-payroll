defmodule MultiCountryPayroll.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias MultiCountryPayroll.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MultiCountryPayroll.DataCase
    end
  end

  setup _tags do
    # Simplified for CI with SQLite
    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r/%{\w+}/, message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end