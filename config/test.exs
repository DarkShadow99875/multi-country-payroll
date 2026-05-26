import Config

# Use SQLite for fast tests in CI (no external DB needed)
config :multi_country_payroll, MultiCountryPayroll.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: ":memory:",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Oban configuration for test (inline mode)
config :multi_country_payroll, Oban, testing: :inline

# DNSCluster dummy config for test (not needed in CI)
config :multi_country_payroll, :dns_cluster_query, nil

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :multi_country_payroll, MultiCountryPayrollWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test_secret_key_base_for_testing_purposes_only",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true