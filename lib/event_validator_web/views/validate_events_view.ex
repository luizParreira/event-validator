defmodule EventValidatorWeb.ValidateEventsView do
  use EventValidatorWeb, :view

  def render("validate_events.json", %{source_id: source_id}) do
    %{data: %{source_id: source_id}}
  end
end
