defmodule Peepy.AuthErrorHandler do

  use Peepy.Web, :controller

  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> render(Peepy.ErrorView, "401.json")

  end

  def unauthorized(conn, params) do
    conn
    |> put_status(403)
    |> render(Peepy.ErrorView, "403.json")
  end

end
