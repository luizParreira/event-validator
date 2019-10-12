defmodule EventValidator.JWT do
  def encode_token(user, claims) do
    {:ok, token, _} =
      EventValidator.Guardian.encode_and_sign(user, claims,
        token_type: :access,
        ttl: {4, :weeks}
      )

    token
  end
end
