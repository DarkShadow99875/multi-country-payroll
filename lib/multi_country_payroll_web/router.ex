defmodule MultiCountryPayrollWeb.Router do
  use MultiCountryPayrollWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MultiCountryPayrollWeb.Layouts, :app}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", MultiCountryPayrollWeb do
    pipe_through :browser

    live "/", DashboardLive, :index
    live "/employees/new", EmployeeFormLive, :new
    live "/analytics", AnalyticsLive, :index
    live "/role-management", RoleManagementLive, :index
  end

  if Application.compile_env(:multi_country_payroll, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MultiCountryPayrollWeb.Telemetry
    end
  end
end
