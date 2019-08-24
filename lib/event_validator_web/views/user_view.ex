defmodule EventValidatorWeb.UserView do
  use EventValidatorWeb, :view

  def render("user.json", %{user: user}) do
    %{data: %{id: user.id}}
  end
end
