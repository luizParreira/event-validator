# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :event_validator,
  ecto_repos: [EventValidator.Repo]

# Configures the endpoint
config :event_validator, EventValidatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bZKrW5cFpXvvCjJ2zCZTmtyGixTgcHEQqWtx5XRGFQNgrmCehhzJ2m5rce+glW8+",
  render_errors: [view: EventValidatorWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: EventValidator.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: EventValidator.Coherence.User,
  repo: EventValidator.Repo,
  module: EventValidator,
  web_module: EventValidatorWeb,
  router: EventValidatorWeb.Router,
  password_hashing_alg: Comeonin.Bcrypt,
  messages_backend: EventValidatorWeb.Coherence.Messages,
  registration_permitted_attributes: [
    "email",
    "name",
    "password",
    "current_password",
    "password_confirmation"
  ],
  invitation_permitted_attributes: ["name", "email"],
  password_reset_permitted_attributes: [
    "reset_password_token",
    "password",
    "password_confirmation"
  ],
  session_permitted_attributes: ["remember", "email", "password"],
  email_from_name: "Validata",
  email_from_email: "contact@validata.com",
  opts: [:authenticatable, :recoverable, :trackable, :confirmable, :registerable]

config :coherence, EventValidatorWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")

# %% End Coherence Configuration %%
