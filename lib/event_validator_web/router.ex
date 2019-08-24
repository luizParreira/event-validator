defmodule EventValidatorWeb.Router do
  use EventValidatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventValidatorWeb do
    pipe_through :api

    resources "/event_schemas", EventSchemaController, except: [:new, :edit]
    post "/users", UserController, :create
  end
end
