defmodule EventValidatorWeb.Router do
  use EventValidatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug EventValidatorWeb.Plug.Auth.AccessPipeline
  end

  pipeline :projects_auth do
    plug EventValidatorWeb.Plug.Projects.Auth
  end

  scope "/", EventValidatorWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/reset_password", PasswordsController, :reset_password
    post "/passwords", PasswordsController, :update
  end

  scope "/auth", EventValidatorWeb do
    pipe_through :api

    post "/identity/callback", AuthController, :identity_callback
  end

  scope "/", EventValidatorWeb do
    pipe_through [:api, :authenticated]

    resources "/event_schemas", EventSchemaController, except: [:new, :edit]
    resources "/organizations", OrganizationController, only: [:index, :create, :show]
    resources "/sources", SourceController, only: [:index, :create, :show]
  end

  scope "/", EventValidatorWeb do
    pipe_through [:api, :projects_auth]

    resources "/validate", ValidateController, only: [:create]
  end
end
