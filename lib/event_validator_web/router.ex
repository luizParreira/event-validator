defmodule EventValidatorWeb.Router do
  use EventValidatorWeb, :router
  use Coherence.Router

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug Coherence.Authentication.Session
  end

  # Add this block
  scope "/api" do
    pipe_through :api
    coherence_routes()
  end

  # Add this block
  scope "/api" do
    pipe_through :protected_api
    coherence_routes :protected
  end


  scope "/api", EventValidatorWeb do
    pipe_through :api
    resources "/event_schemas", EventSchemaController, except: [:new, :edit]
  end

  scope "/api", EventValidatorWeb do
    pipe_through :protected_api
  end
end
