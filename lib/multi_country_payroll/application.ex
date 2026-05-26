defmodule MultiCountryPayroll.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MultiCountryPayroll.Repo,
      {Phoenix.PubSub, name: MultiCountryPayroll.PubSub},
      MultiCountryPayrollWeb.Endpoint
    ]

    # Oban - only start if not in test (to avoid DB issues in CI)
    children =
      if Mix.env() != :test do
        children ++ [{Oban, Application.fetch_env!(:multi_country_payroll, Oban)}]
      else
        children
      end

    # DNSCluster is optional
    dns_query = Application.get_env(:multi_country_payroll, :dns_cluster_query)
    children =
      if dns_query && dns_query != "" do
        children ++ [{DNSCluster, query: dns_query}]
      else
        children
      end

    opts = [strategy: :one_for_one, name: MultiCountryPayroll.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MultiCountryPayrollWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end