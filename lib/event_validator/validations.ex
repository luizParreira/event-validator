defmodule EventValidator.Validations do
  @moduledoc """
  The Validations context.
  """

  import Ecto.Query, warn: false
  alias EventValidator.Repo

  alias EventValidator.Validations.SchemaValidation
  alias EventValidator.Accounts.Organization
  alias EventValidator.Projects.Source
  alias EventValidator.Events.EventSchema

  @doc """
  Returns the list of schema_validations.

  ## Examples

      iex> list_schema_validations()
      [%SchemaValidation{}, ...]

  """
  def list_schema_validations do
    Repo.all(SchemaValidation)
  end

  @doc """
  Gets a single schema_validation.

  Raises `Ecto.NoResultsError` if the Schema validation does not exist.

  ## Examples

      iex> get_schema_validation!(123)
      %SchemaValidation{}

      iex> get_schema_validation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schema_validation!(id), do: Repo.get!(SchemaValidation, id)

  @doc """
  Creates a schema_validation.

  ## Examples

      iex> create_schema_validation(%{field: value})
      {:ok, %SchemaValidation{}}

      iex> create_schema_validation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schema_validation(attrs \\ %{}) do
    %SchemaValidation{}
    |> SchemaValidation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a schema_validation.

  ## Examples

      iex> create_schema_validation!(%{field: value})
      {:ok, %SchemaValidation{}}

      iex> create_schema_validation!(%{field: bad_value})
      ** (Ecto.NoResultsError)


  """
  def create_schema_validation!(attrs \\ %{}) do
    %SchemaValidation{}
    |> SchemaValidation.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Returns the list of all invalid schema validations

  ## Examples

      iex> list_schema_validations(%Organization{})
      [%SchemaValidation{}, ...]

  """
  def list_schema_validations(%Organization{id: organization_id}) do
    sub =
      from es in EventSchema,
        group_by: [es.id, es.name],
        distinct: es.name,
        order_by: [desc: es.id]

    Repo.all(
      from sv in SchemaValidation,
        join: es in subquery(sub),
        on: es.id == sv.event_schema_id,
        join: s in Source,
        on: s.id == es.source_id,
        where: s.organization_id == ^organization_id,
        preload: [:event_schema]
    )
  end
end
