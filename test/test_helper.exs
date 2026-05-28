ExUnit.start()

# Set up the sandbox for tests
Ecto.Adapters.SQL.Sandbox.mode(MultiCountryPayroll.Repo, :manual)