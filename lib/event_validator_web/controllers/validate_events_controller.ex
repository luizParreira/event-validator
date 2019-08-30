defmodule EventValidatorWeb.ValidateEventsController do
  use EventValidatorWeb, :controller

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, _params) do
    conn
    |> put_status(200)
    |> render("validate_events.json", source_id: conn.assigns.source_id)
  end
end
