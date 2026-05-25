defmodule MultiCountryPayroll.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MultiCountryPayroll.Repo,
      {DNSCluster, query: Application.get_env(:multi_country_payroll, :dns_cluster_query)},
      {Phoenix.PubSub, name: MultiCountryPayroll.PubSub},
      # Oban - Background Jobs
      {Oban, Application.fetch_env!(:multi_country_payroll, Oban)},
      MultiCountryPayrollWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MultiCountryPayroll.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MultiCountryPayrollWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
