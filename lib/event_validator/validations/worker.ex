defmodule EventValidator.Validations.Worker do
  alias EventValidator.{Events, Validations}
  alias Validations.ValidateSchema

  def perform(source_id, %{"event" => event_name, "type" => "track"} = params) do
    case Events.get_event_schema_by(%{source_id: source_id, name: event_name}) do
      nil -> Events.infer_event_schema(params, source_id)
      event_schema -> ValidateSchema.validate(event_schema, params)
    end
  end

  def perform(source_id, params) do
    {:ok, params}
  end
end
