defmodule QuickExWeb.Router do
  use QuickExWeb, :router

  pipeline :api do
    #    plug :accepts, ["json", "multipart"]
  end

  scope "/api", QuickExWeb do
    pipe_through :api
  end

  post "/api/create", QuickExWeb.ApiController, :create
  get "/api/get/:id", QuickExWeb.ApiController, :get
  delete "/api/delete/:id", QuickExWeb.ApiController, :delete
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: QuickExWeb.Telemetry
    end
  end
end
