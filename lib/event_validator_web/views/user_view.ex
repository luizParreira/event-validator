defmodule EventValidatorWeb.UserView do
  use EventValidatorWeb, :view

  def render("user.json", %{user: user, token: token}) do
    %{data: %{id: user.id, token: token}}
  end
end
