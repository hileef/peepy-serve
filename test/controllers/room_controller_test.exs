defmodule Peepy.RoomControllerTest do
  use Peepy.ConnCase

  alias Peepy.Room
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %Peepy.User{}
    {:ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = conn
            |> put_req_header("content-type", "application/vnd.api+json")
            |> put_req_header("authorization", "Bearer #{jwt}")


    {:ok, conn: conn, user: user}
  end

  defp create_test_rooms(user) do
    Enum.each ["first room", "second room", "third room"] , fn room_name ->
      Repo.insert! %Peepy.Room{owner_id: user.id, name: room_name}
    end

    other_user = Repo.insert! %Peepy.User{}
    Enum.each ["fourth room", "firth room"] , fn room_name ->
      Repo.insert! %Peepy.Room{owner_id: other_user.id, name: room_name}
    end

  end

  test "lists all entries on index", %{conn: conn, user: user} do
    create_test_rooms user
    conn = get conn, room_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "lists owned entries on index (owner_id = user id)", %{conn: conn, user: user} do
    create_test_rooms user
    conn = get conn, room_path(conn, :index, user_id: user.id)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = get conn, room_path(conn, :show, room)
    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(room.id),
      "type" => "room",
      "attributes" => %{ "name" => room.name },
      "relationships" => %{
        "owner" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/users/#{user.id}"
          }
        }
      }
    }
    # assert json_response(conn, 200)["data"] == %{"id" => room.id,
    #   "name" => room.name,
    #   "owner_id" => room.owner_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = post conn, room_path(conn, :create), data: %{type: "rooms", attributes: @valid_attrs, relationships: %{}}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, room_path(conn, :create), data: %{type: "rooms", attributes: @invalid_attrs, relationships: %{}}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id, name: "a room"}
    conn = put conn, room_path(conn, :update, room), data: %{id: room.id, type: "rooms", attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = put conn, room_path(conn, :update, room), data: %{id: room.id, type: "rooms", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = delete conn, room_path(conn, :delete, room)
    assert response(conn, 204)
    refute Repo.get(Room, room.id)
  end
end
