defmodule EventValidatorWeb.Plug.Auth.AccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :event_validator

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end
