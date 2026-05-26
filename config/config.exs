import Config

config :multi_country_payroll,
  ecto_repos: [MultiCountryPayroll.Repo],
  generators: [timestamp_type: :utc_datetime]

config :phoenix, :json_library, Jason

# PDF Export with ChromicPDF
config :chromic_pdf,
  chrome_path: System.get_env("CHROME_PATH") || "/usr/bin/google-chrome-stable"

config :esbuild,
  version: "0.25.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tailwind,
  version: "4.0.9",
  default: [
    args: ~w(
      --input=css/app.css
      --output=../priv/static/assets/app.css
      --watch
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Oban configuration (under the app namespace as expected by Application.fetch_env!)
config :multi_country_payroll, Oban,
  repo: MultiCountryPayroll.Repo,
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"