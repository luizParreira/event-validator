defmodule EventValidatorWeb.Router do
  use EventValidatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug EventValidatorWeb.Plug.Auth.AccessPipeline
  end

  scope "/", EventValidatorWeb do
    pipe_through :api

    post "/users", UserController, :create
    resources "/event_schemas", EventSchemaController, except: [:new, :edit]
  end

  scope "/auth", EventValidatorWeb do
    pipe_through :api

    post "/identity/callback", AuthController, :identity_callback
  end

  scope "/", EventValidatorWeb do
    pipe_through :api
    pipe_through :authenticated
  end
end
