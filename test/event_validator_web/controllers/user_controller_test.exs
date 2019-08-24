defmodule EventValidatorWeb.UserControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.Accounts

  @create_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @invalid_attrs %{email: nil, encrypted_password: nil, name: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      response = json_response(conn, 201)["data"]

      assert %{"id" => id} = response
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
