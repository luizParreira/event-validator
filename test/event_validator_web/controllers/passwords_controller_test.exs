defmodule EventValidatorWeb.PasswordsControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.Accounts


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "reset password" do
    test "sets an reset password token when the user exists and returns 204", %{conn: conn} do
      email = "bruno@validata.app"

      {:ok, user} = Accounts.create_user(%{
        email: email,
        password: "some password",
        name: "some name"
      })

      conn = post(build_conn(), Routes.passwords_path(conn, :reset_password), email: email)

      assert conn.status == 204

      assert Accounts.get_user!(user.id).reset_password_token != nil
    end

    test "returns 404 when the users doesn't exist", %{conn: conn} do
      conn = post(build_conn(), Routes.passwords_path(conn, :reset_password), email: "inexistent@email.com")

      assert conn.status == 404
    end
  end
end
