defmodule EventValidator.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias EventValidator.Repo

  alias EventValidator.Projects.Source

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%Source{}, ...]

  """
  def list_sources do
    Repo.all(Source)
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
  def get_source(id), do: Repo.get(Source, id)

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %Source{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs \\ %{}) do
    %Source{}
    |> Source.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a source.

  ## Examples

      iex> update_source(source, %{field: new_value})
      {:ok, %Source{}}

      iex> update_source(source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source(%Source{} = source, attrs) do
    source
    |> Source.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Source.

  ## Examples

      iex> delete_source(source)
      {:ok, %Source{}}

      iex> delete_source(source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source(%Source{} = source) do
    Repo.delete(source)
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
