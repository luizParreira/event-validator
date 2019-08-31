use Mix.Config

# Configure your database
config :event_validator, EventValidator.Repo,
  username: "postgres",
  password: "test",
  database: "event_validator_test",
  hostname: "test_db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :event_validator, EventValidatorWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Speed up tests
config :argon2_elixir, log_rounds: 4

config :event_validator, EventValidator.Guardian,
  issuer: "validata",
  secret_key: "secret-key"

config :verk,
  queues: [],
  redis_url: {:system, "REDIS_URL", "redis://redis:6379/2"}

config :event_validator, :project_auth, "secret-key"
