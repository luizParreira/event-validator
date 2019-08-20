defmodule EventValidatorWeb.Coherence.SessionView do
  use EventValidatorWeb.Coherence, :view

  def render("session.json", %{user: user}) do
    %{
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        confirmed_at: user.confirmed_at
      }
    }
  end

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end

  def render("error.json", _opts) do
    %{
      error: "Invalid credentials"
    }
  end
end
