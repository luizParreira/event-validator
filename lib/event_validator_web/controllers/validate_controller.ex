defmodule EventValidatorWeb.ValidateController do
  use EventValidatorWeb, :controller

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, _params) do
  %{source_id: conn.assigns.source_id, params: conn.body_params}
    |> EventValidator.Validations.Worker.new()
    |> Oban.insert()

    send_resp(conn, :no_content, "")
  end
end
