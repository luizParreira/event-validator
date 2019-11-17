defmodule EventValidator.Validations.Worker do
  use Oban.Worker, queue: "events", max_attempts: 10

  alias EventValidator.{Events, Validations}
  alias Validations.ValidateSchema


  @impl Oban.Worker
  def perform( %{"source_id"  => source_id, "params" => %{"event" => event_name} = params}, _job) do
    case Events.get_event_schema(source_id, event_name) do
      nil -> Events.infer_event_schema(params, source_id)
      event_schema ->
        ValidateSchema.validate(event_schema, params)
    end
  end

  @impl Oban.Worker
  def perform(params, _job) do
    {:ok, params}
  end
end
