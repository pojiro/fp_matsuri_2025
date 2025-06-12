defmodule FpMatsuri2025Web.Router do
  use FpMatsuri2025Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FpMatsuri2025Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FpMatsuri2025Web do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", Live.Home
  end

  # Other scopes may use custom stacks.
  # scope "/api", FpMatsuri2025Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:fp_matsuri_2025, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FpMatsuri2025Web.Telemetry
    end
  end
end
