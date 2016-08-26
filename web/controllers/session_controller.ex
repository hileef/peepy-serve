defmodule Peepy.SessionController do
  use Peepy.Web, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  alias Peepy.User

  def create(conn, %{"grant_type" => "password",
    "username" => username,
    "password" => password
  }) do

    try do

      user = User
              |> where(email: ^username)
              |> Repo.one!

      cond do

        checkpw(password, user.password_hash) ->

          # Passwords match
          Logger.info "User" <> username <> " just logged in"
          {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt})

        true ->

          # Passwords don't match
          Logger.warn "User " <> username <> " just failed to login"
          conn
          |> put_status(401)
          |> render(Peepy.ErrorView, "401.json")

      end

    rescue

      e ->

        IO.inspect e # Print error in intelligible format to stdout
        Logger.error "Unexpected error while attempting to login user " <> username
        conn
        |> put_status(401)
        |> render(Peepy.ErrorView, "401.json")

    end


  end


  def create(conn, %{"grant_type" => _other}) do
    throw "Unsupported grant_type"
  end

end
