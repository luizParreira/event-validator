defmodule EventValidatorWeb.OrganizationControllerTest do
  use EventValidatorWeb.ConnCase

  alias EventValidator.{Accounts, Projects}
  alias EventValidator.JWT

  @user_attrs %{
    email: "some@email.com",
    password: "some password",
    name: "some name"
  }

  @create_attrs %{
    name: "some name",
    website: "some website"
  }

  @invalid_attrs %{name: nil, website: nil}

  def fixture(:organization) do
    {:ok, organization} = Accounts.create_organization(@create_attrs)
    organization
  end

  def fixture(:user_organization, user_id, org_id) do
    {:ok, user_organization} =
      Accounts.create_user_organization(%{user_id: user_id, organization_id: org_id})

    user_organization
  end

  setup %{conn: conn} do
    {:ok, user} = EventValidator.Accounts.create_user(@user_attrs)
    token = JWT.encode_token(user, %{})

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer: " <> token),
     user: user}
  end

  describe "index" do
    test "lists all organizations for a user when there is none", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all organizations", %{conn: conn, user: user} do
      org = fixture(:organization)
      _user_org = fixture(:user_organization, user.id, org.id)
      conn = get(conn, Routes.organization_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => org.id,
                 "name" => org.name,
                 "website" => org.website,
                 "sources" => []
               }
             ]
    end
  end

  describe "show" do
    test "show a organization", %{conn: conn, user: user} do
      org = fixture(:organization)
      _user_org = fixture(:user_organization, user.id, org.id)

      source_attrs = %{
        name: "some name",
        organization_id: org.id
      }

      {:ok, source} = Projects.create_source(source_attrs)
      conn = get(conn, Routes.organization_path(conn, :show, org.id))

      assert json_response(conn, 200)["data"] == %{
               "id" => org.id,
               "name" => "some name",
               "sources" => [
                 %{
                   "id" => source.id,
                   "name" => "some name",
                   "token" => source.source_token.token,
                   "events" => []
                 }
               ],
               "website" => "some website"
             }
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @create_attrs)
      response = json_response(conn, 201)["data"]
      id = response["id"]

      assert %{
               "name" => "some name",
               "website" => "some website"
             } = response

      [org] = Accounts.list_organizations(user_id: user.id)
      assert id == org.id
      assert "some name" == org.name
      assert "some website" == org.website
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
