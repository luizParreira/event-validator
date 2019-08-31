defmodule EventValidatorWeb.SourceControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{JWT, Accounts, Projects}

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @create_attrs %{
    name: "some name",
    organization_id: nil
  }

  @org_attrs %{
    name: "some name",
    size: "1-10",
    website: "some website"
  }

  @invalid_attrs %{name: nil, platform: nil}

  def setup_fixture do
    {:ok, user} = Accounts.create_user(@user_attrs)
    {:ok, organization} = Accounts.create_organization(@org_attrs, user.id)
    {user, organization}
  end

  setup %{conn: conn} do
    {user, organization} = setup_fixture()
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token),
     organization: organization}
  end

  describe "index" do
    test "lists all sources", %{conn: conn, organization: organization} do
      attrs = %{@create_attrs | organization_id: organization.id}
      {:ok, source} = Projects.create_source(attrs)
      source_token = EventValidator.Repo.preload(source, :source_token).source_token

      conn = get(conn, Routes.source_path(conn, :index), %{organization_id: organization.id})

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => source.id,
                 "name" => source.name,
                 "token" => source_token.token
               }
             ]
    end
  end

  describe "create source" do
    test "renders source when data is valid", %{conn: conn, organization: organization} do
      attrs = %{@create_attrs | organization_id: organization.id}
      conn = post(conn, Routes.source_path(conn, :create), source: attrs)

      assert %{"name" => "some name"} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.source_path(conn, :create), source: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
