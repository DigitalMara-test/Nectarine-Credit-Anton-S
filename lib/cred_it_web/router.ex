defmodule CredItWeb.Router do
  use CredItWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CredItWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CredItWeb do
    pipe_through :browser

    resources "/survey", SurveyController, only: [:new, :create], singleton: true do
      get "/decline", SurveyController, :decline
    end
    resources "/offer", OfferController, only: [:new, :create], singleton: true do
      get "/result", OfferController, :result
      post "/send", OfferController, :send
    end

    get "/done", PageController, :done
    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", CredItWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cred_it, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CredItWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
