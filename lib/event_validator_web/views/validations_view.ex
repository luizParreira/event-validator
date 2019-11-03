defmodule EventValidatorWeb.ValidationsView do
  use EventValidatorWeb, :view

  def render("index.json", %{validations: validations}) do
    %{data: Enum.map(validations, &Map.from_struct/1)}
  end
end
