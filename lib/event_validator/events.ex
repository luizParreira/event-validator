defmodule EventValidator.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias EventValidator.Repo

  alias EventValidator.Events.EventSchema

  @doc """
  Returns the list of event_schemas.

  ## Examples

      iex> list_event_schemas()
      [%EventSchema{}, ...]

  """
  def list_event_schemas do
    Repo.all(EventSchema)
  end

  @doc """
  Gets a single event_schema.

  Raises `Ecto.NoResultsError` if the Event schema does not exist.

  ## Examples

      iex> get_event_schema!(123)
      %EventSchema{}

      iex> get_event_schema!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_schema!(id), do: Repo.get!(EventSchema, id)

  @doc """
  Gets a single event_schema.

  Raises `Ecto.NoResultsError` if the Event schema does not exist.

  ## Examples

      iex> get_event_schema_by!(123)
      %EventSchema{}

      iex> get_event_schema_by!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_schema_by!(attrs \\ %{}), do: Repo.get_by!(EventSchema, attrs)

  @doc """
  Gets a single event_schema.

  Return `nil` if the Event schema does not exist.

  ## Examples

      iex> get_event_schema_by(123)
      %EventSchema{}

      iex> get_event_schema_by(456)
      nil

  """
  def get_event_schema_by(attrs \\ %{}), do: Repo.get_by(EventSchema, attrs)

  @doc """
  Creates a event_schema.

  ## Examples

      iex> create_event_schema(%{field: value})
      {:ok, %EventSchema{}}

      iex> create_event_schema(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_schema(attrs \\ %{}) do
    %EventSchema{}
    |> EventSchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_schema.

  ## Examples

      iex> update_event_schema(event_schema, %{field: new_value})
      {:ok, %EventSchema{}}

      iex> update_event_schema(event_schema, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_schema(%EventSchema{} = event_schema, attrs) do
    event_schema
    |> EventSchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EventSchema.

  ## Examples

      iex> delete_event_schema(event_schema)
      {:ok, %EventSchema{}}

      iex> delete_event_schema(event_schema)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_schema(%EventSchema{} = event_schema) do
    Repo.delete(event_schema)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_schema changes.

  ## Examples

      iex> change_event_schema(event_schema)
      %Ecto.Changeset{source: %EventSchema{}}

  """
  def change_event_schema(%EventSchema{} = event_schema) do
    EventSchema.changeset(event_schema, %{})
  end

  def infer_event_schema(params, source_id) do
    event_name = params["event"]
    schema = EventValidator.Events.InferSchema.infer(%{"event_params" => params})

    create_event_schema(%{
      name: event_name,
      source_id: source_id,
      schema: schema,
      confirmed: false
    })
  end
end
