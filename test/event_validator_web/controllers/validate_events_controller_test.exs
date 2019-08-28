defmodule EventValidatorWeb.ValidateEventsControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{Projects, Accounts}
  alias Projects.{TokenManager, SourceToken}

  @create_attrs %{
    name: "some name",
    platform: "some platform",
    organization_id: nil
  }
  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }
  @org_attrs %{
    name: "some name",
    size: "1-10",
    website: "some website"
  }

  def fixture(:source) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)
    {:ok, source} = Projects.create_source(%{@create_attrs | organization_id: organization.id})
    source
  end

  setup %{conn: conn} do
    source = fixture(:source)
    {:ok, %SourceToken{token: token}} = TokenManager.encode_token(source)

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("auth-token", token),
     source: source}
  end

  describe "create source" do
    test "renders no content valid when token present", %{conn: conn, source: source} do
      conn = post(conn, "/validate_events")
      assert json_response(conn, 200) == %{"data" => %{"source_id" => source.id}}
    end

    test "renders auth error when token invalid", %{conn: conn} do
      conn = put_req_header(conn, "auth-token", "wrong-token")
      conn = post(conn, "/validate_events")

      assert json_response(conn, 401) == %{"errors" => %{"title" => "UnauthorizedRequest"}}
    end
  end
end
