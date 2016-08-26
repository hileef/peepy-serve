defmodule Peepy.UserController do

  use Peepy.Web, :controller

  alias Peepy.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Peepy.AuthErrorHandler

  def current(conn, _) do

    user = conn
            |> Guardian.Plug.current_resource

    conn
    |> render(Peepy.UserView, "show.json", user: user)

  end


end
