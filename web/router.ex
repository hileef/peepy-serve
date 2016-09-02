defmodule Peepy.Router do
  use Peepy.Web, :router

  # Any status
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Must be logged in
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Peepy do
    pipe_through :api

    post "/register", RegistrationController, :create
    post "/token", SessionController, :create, as: :login

  end

  scope "/api", Peepy do
    pipe_through :api_auth

    resources "users", UserController, only: [:index, :show] do
      get "rooms", RoomController, :index, as: :rooms
    end
    
    resources "rooms", RoomController, except: [:new, :edit]

  end


end
