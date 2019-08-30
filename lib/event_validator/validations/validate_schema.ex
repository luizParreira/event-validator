defmodule EventValidator.Validations.ValidateSchema do
  alias EventValidator.{Events, Validations}
  alias Events.EventSchema

  def validate(_schema, nil), do: {:error, :no_params}

  def validate(%EventSchema{schema: schema, id: id}, params) do
    Validations.create_schema_validation!(%{
      event_schema_id: id,
      valid: ExJsonSchema.Validator.valid?(schema, params),
      event_params: params
    })
  end
end
