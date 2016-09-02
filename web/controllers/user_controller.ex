defmodule Peepy.UserController do

  use Peepy.Web, :controller

  alias Peepy.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Peepy.AuthErrorHandler

  def current(conn, _) do

    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render(Peepy.UserView, "show.json-api", data: user)

  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json-api", data: users)
  end

  def show(conn, %{user_id: user_id}) do
    user = Repo.get!(User, user_id)
    render(conn, "show.json-api", data: user)
  end


end
