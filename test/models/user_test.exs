defmodule Peepy.UserTest do
  use Peepy.ModelCase

  alias Peepy.User

  @valid_attrs %{email: "blergh@blergh.com", password: "guestguest", password_confirmation: "guestguest"}
  @invalid_email %{email: "blerghlergh.com", password: "guestguest", password_confirmation: "guestguest"}
  @invalid_match %{email: "blerghlergh.com", password: "guestguest", password_confirmation: "lalalalala"}
  @invalid_pwd %{email: "blerghlergh.com", password: "guest", password_confirmation: "guest"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid email" do
    changeset = User.changeset(%User{}, @invalid_email)
    refute changeset.valid?
  end

  test "changeset with passwords not matching" do
    changeset = User.changeset(%User{}, @invalid_match)
    refute changeset.valid?
  end

  test "changeset with invalid password" do
    changeset = User.changeset(%User{}, @invalid_pwd)
    refute changeset.valid?
  end

end
