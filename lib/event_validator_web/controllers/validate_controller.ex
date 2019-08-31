defmodule EventValidatorWeb.ValidateController do
  use EventValidatorWeb, :controller

  action_fallback EventValidatorWeb.FallbackController

  def create(conn, _params) do
    verk_job = %Verk.Job{
      queue: :default,
      class: "EventValidator.Validations.Worker",
      args: [conn.assigns.source_id, conn.body_params]
    }

    {:ok, _} = Verk.enqueue(verk_job)

    send_resp(conn, :no_content, "")
  end
end
