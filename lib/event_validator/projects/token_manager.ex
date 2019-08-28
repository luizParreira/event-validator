defmodule EventValidator.Projects.TokenManager do
  alias EventValidator.Projects.Source
  alias EventValidator.Projects

  def encode_token(%Source{id: id}) do
    token = Phoenix.Token.sign(EventValidatorWeb.Endpoint, secret(), id)
    Projects.create_source_token(%{source_id: id, token: token})
  end

  def decode_token(nil), do: {:error, :unauthorized}

  def decode_token(token) do
    Phoenix.Token.verify(EventValidatorWeb.Endpoint, secret(), token, max_age: :infinity)
  end

  def secret, do: Application.get_env(:event_validator, :project_auth)
end
