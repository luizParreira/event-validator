defmodule EventValidator.Repo do
  use Ecto.Repo,
    otp_app: :event_validator,
    adapter: Ecto.Adapters.Postgres
end
