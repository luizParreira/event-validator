defmodule EventValidatorWeb.Router do
  use EventValidatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventValidatorWeb do
    pipe_through :api
  end
end
