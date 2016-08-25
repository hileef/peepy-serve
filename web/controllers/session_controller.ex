defmodule Peepy.SessionController do
  use Peepy.Web, :controller

  def index(conn, _params) do

    conn
    |> json(%{status: "Ok"})

  end
end
