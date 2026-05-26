defmodule MultiCountryPayrollWeb.Router do
  use MultiCountryPayrollWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MultiCountryPayrollWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MultiCountryPayrollWeb do
    pipe_through :browser

    live "/", DashboardLive, :index
    live "/employee-portal", EmployeePortalLive, :index
    live "/analytics", AnalyticsLive, :index
    live "/login", LoginLive, :index
    live "/admin/roles", RoleManagementLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MultiCountryPayrollWeb do
  #   pipe_through :api
  # end
end