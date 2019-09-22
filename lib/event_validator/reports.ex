defmodule EventValidator.Reports do
  alias EventValidator.Validations
  alias ExJsonSchema.Validator
  alias EventValidator.Accounts.Organization

  defmodule Error do
    defstruct [:event, :error_message, :path, :error_count]
  end

  def event_validation_report(%Organization{} = organization) do
    organization
    |> Validations.list_schema_validations()
    |> Enum.flat_map(fn event_validation ->
      case Validator.validate(event_validation.event_schema.schema, event_validation.event_params) do
        :ok -> []
        {:error, error} -> [{event_validation, error}]
      end
    end)
    |> Enum.group_by(fn {event_validation, _} ->
      event_validation.event_schema
    end)
    |> Enum.flat_map(fn {event_schema, errors_list} ->
      errors_list
      |> Enum.group_by(fn {_, error} -> error end)
      |> Enum.map(fn {error_text, errors} ->
        [{error_message, path}] = error_text

        %Error{
          event: event_schema.name,
          error_message: error_message,
          path: path,
          error_count: Enum.count(errors)
        }
      end)
    end)
  end
end
