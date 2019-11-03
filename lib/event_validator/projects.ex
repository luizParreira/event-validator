defmodule EventValidator.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias EventValidator.Repo
  alias Ecto.Multi

  alias EventValidator.Projects.{Source, TokenManager}

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%Source{}, ...]

  """
  def list_sources do
    Source
    |> Repo.all()
  end

  def list_sources(organization_id: organization_id) do
    case Repo.all(
           from o in Source,
             where: o.organization_id == ^organization_id
         ) do
      [] -> []
      nil -> []
      sources -> sources
    end
  end

  @doc """
  Gets a single source.

  Raises `nil` if the Source does not exist.

  ## Examples

      iex> get_source(123)
      %Source{}

      iex> get_source(456)
      nil

  """
  def get_source(id),
    do: Repo.get(Source, id)

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %Source{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs \\ %{}) do
    multi_struct =
      Multi.new()
      |> Multi.insert(:source, Source.changeset(%Source{}, attrs))
      |> Multi.run(:source_token, fn _, %{source: source} ->
        TokenManager.encode_token(source)
      end)

    case Repo.transaction(multi_struct) do
      {:ok, %{source: source, source_token: _source_token}} ->
        {:ok, source}

      {:error, :source_token, source_token_changeset, _changes_so_far} ->
        {:error, source_token_changeset}

      {:error, :source, source_changeset, _changes_so_far} ->
        {:error, source_changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source changes.

  ## Examples

      iex> change_source(source)
      %Ecto.Changeset{source: %Source{}}

  """
  def change_source(%Source{} = source) do
    Source.changeset(source, %{})
  end

  alias EventValidator.Projects.SourceToken

  @doc """
  Gets a single source_token.

  Raises `Ecto.NoResultsError` if the Source token does not exist.

  ## Examples

      iex> get_source_token!(123)
      %SourceToken{}

      iex> get_source_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source_token!(id), do: Repo.get!(SourceToken, id)

  @doc """
  Gets a single source_token by `source_id`.

  Raises `nil` if the Source token does not exist.

  ## Examples

      iex> get_source_token(source_id: 123)
      %SourceToken{}

      iex> get_source_token(source_id: 456)
      nil

  """
  def get_source_token(source_id: id), do: Repo.get_by(SourceToken, source_id: id)

  @doc """
  Creates a source_token.

  ## Examples

      iex> create_source_token(%{field: value})
      {:ok, %SourceToken{}}

      iex> create_source_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source_token(attrs \\ %{}) do
    %SourceToken{}
    |> SourceToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source_token changes.

  ## Examples

      iex> change_source_token(source_token)
      %Ecto.Changeset{source: %SourceToken{}}

  """
  def change_source_token(%SourceToken{} = source_token) do
    SourceToken.changeset(source_token, %{})
  end
end
