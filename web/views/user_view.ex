defmodule Peepy.UserView do
  use Peepy.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email]
  has_many :rooms, link: :rooms_link

  def rooms_link(user, conn) do
    user_rooms_url(conn, :index, user.id)
  end

  # def render("index.json", %{users: users}) do
  #   %{data: render_many(users, Peepy.UserView, "user.json")}
  # end
  #
  # def render("show.json", %{user: user}) do
  #   %{data: render_one(user, Peepy.UserView, "user.json")}
  # end
  #
  # def render("user.json", %{user: user}) do
  #   %{
  #     "type": "user",
  #     "id": user.id,
  #     "attributes": %{
  #       "email": user.email
  #     }
  #   }
  # end

end
