defmodule EventValidatorWeb.AuthControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.Accounts

  @create_attrs %{
    email: "some@email.com",
    password: "password",
    name: "Some name"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    test "renders user when data is valid", %{conn: conn} do
      user = fixture(:user)

      conn =
        post(conn, "/auth/identity/callback", user: %{email: user.email, password: "password"})

      response = json_response(conn, 200)["data"]

      assert %{"id" => id} = response
      assert Map.has_key?(response, "token")
    end

    test "renders unauthorized when invalid", %{conn: conn} do
      conn =
        post(conn, "/auth/identity/callback", user: %{email: "any@email.com", password: "wrong"})

      assert json_response(conn, 401)["errors"]["title"] == "UnauthorizedRequest"
    end
  end

  describe "bad request" do
    test "renders bad request when the payload is incorrect", %{conn: conn} do
      conn = post(conn, "/auth/identity/callback", user: %{invalid: "payload"})

      assert json_response(conn, 400)["errors"] == %{"title" => "BadRequest"}
    end
  end
end
