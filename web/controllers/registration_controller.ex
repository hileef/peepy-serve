defmodule Peepy.RegistrationController do
  use Peepy.Web, :controller

  alias Peepy.User

  def create(conn, %{"data" => %{"type" => "users",
    "attributes" => %{
      "email" => email,
      "password" => password,
      "password-confirmation" => password_confirmation
    }
  }}) do

    changeset = User.changeset %User{}, %{
      email: email, password: password, password_confirmation: password_confirmation
    }

    case Repo.insert changeset do

      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Peepy.UserView, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peepy.ChangesetView, "error.json", changeset: changeset)

    end


  end
end
