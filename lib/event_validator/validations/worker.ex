defmodule EventValidator.Validations.Worker do
  alias EventValidator.{Events, Validations}
  alias Validations.ValidateSchema

  def perform(source_id, %{"event" => event_name, "type" => "track"} = params) do
    event_schema = Events.get_event_schema_by!(%{source_id: source_id, name: event_name})
    ValidateSchema.validate(event_schema, params)
  end

  def perform(source_id, params) do
    {:ok, params}
  end
end
