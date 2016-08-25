defmodule Peepy.Router do
  use Peepy.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Peepy do
    pipe_through :api

    # Route to session controller
    resources "session", SessionController, only: [:index]


  end
end
