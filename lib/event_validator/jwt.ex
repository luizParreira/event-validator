defmodule EventValidator.JWT do
  def encode_token(user, claims) do
    {:ok, token, _} =
      EventValidator.Guardian.encode_and_sign(user, claims,
        token_type: :access,
        ttl: {2, :hours}
      )

    token
  end
end
