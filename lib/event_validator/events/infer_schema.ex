defmodule EventValidator.Events.InferSchema do
  def infer(%{"event_params" => event_params}) when is_map(event_params) do
    event =
      event_params
      |> Enum.filter(fn {_, v} -> v end)
      |> Map.new()

    %{
      "type" => "object",
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "required" => Map.keys(event),
      "properties" =>
        event
        |> Enum.map(fn {k, v} -> {k, infer(v)} end)
        |> Map.new()
    }
  end

  def infer(schema_value) when is_map(schema_value) and map_size(schema_value) == 0 do
    %{"type" => "object"}
  end

  def infer(schema_value) when is_map(schema_value) and map_size(schema_value) > 0 do
    event =
      schema_value
      |> Enum.filter(fn {_, v} -> v end)
      |> Map.new()

    %{
      "type" => "object",
      "required" => Map.keys(event),
      "properties" =>
        event
        |> Enum.map(fn {k, v} -> {k, infer(v)} end)
        |> Map.new()
    }
  end

  def infer(schema_value) when is_number(schema_value) do
    %{"type" => "number", "examples" => [schema_value]}
  end

  def infer([]) do
    %{
      "type" => "array"
    }
  end

  def infer(schema_value) when is_list(schema_value) and length(schema_value) > 0 do
    %{
      "type" => "array",
      "items" => infer(Enum.at(schema_value, 0))
    }
  end

  # Fallback to being a string
  def infer(schema_value) do
    %{
      "type" => "string",
      "examples" => ["#{schema_value}"]
    }
  end
end
