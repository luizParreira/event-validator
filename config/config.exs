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

config :event_validator, EventValidator.Guardian,
  issuer: "validata",
  secret_key: System.get_env("AUTH_SECRET_KEY")

config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    identity:
      {Ueberauth.Strategy.Identity,
       [
         callback_methods: ["POST"],
         nickname_field: :email,
         param_nesting: "user",
         uid_field: :email
       ]}
  ]

config :event_validator, EventValidatorWeb.Plug.Auth.AccessPipeline,
  module: EventValidator.Guardian,
  error_handler: EventValidatorWeb.Plug.Auth.ErrorHandler

config :event_validator, :project_auth, System.get_env("PROJECTS_SECRET_KEY")

config :verk,
  max_retry_count: 10,
  poll_interval: {:system, :integer, "VERK_POLL_INTERVAL", 5000},
  start_job_log_level: :info,
  done_job_log_level: :info,
  fail_job_log_level: :info,
  node_id: {:system, "DYNO", "job.1"},
  redis_url: {:system, "REDIS_URL", "redis://redis:6379"}

config :event_validator, EventValidator.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :verk_web, VerkWeb.Endpoint, url: [path: "/verk"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
