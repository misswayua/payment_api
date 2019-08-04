defmodule PromoCode.Promo_codes do
  @moduledoc """
  The Promo_codes context.
  """
  import Ecto.Query, warn: false
  alias PromoCode.Repo

  alias PromoCode.Promo_codes.Promo_code

  @doc """
  Returns the list of promo_codes.

  ## Examples

      iex> list_promo_codes()
      [%Promo_code{}, ...]

  """
  def list_promo_codes do
    Repo.all(Promo_code)
  end

  @doc """
  Gets a single promo_code.

  Raises `Ecto.NoResultsError` if the Promo code does not exist.

  ## Examples

      iex> get_promo_code!(123)
      %Promo_code{}

      iex> get_promo_code!(456)
      ** (Ecto.NoResultsError)

  """
  def get_promo_code(id), do: Repo.get(Promo_code, id)

  @doc """
  Creates a promo_code.

  ## Examples

      iex> create_promo_code(%{field: value})
      {:ok, %Promo_code{}}

      iex> create_promo_code(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_promo_code(attrs \\ %{}) do
    code = Ecto.UUID.generate()

    attributes = Map.merge(attrs, %{"code" => code})

    %Promo_code{}
    |> Promo_code.changeset(attributes)
    |> Repo.insert()
  end

  @doc """
  Updates a promo_code.

  ## Examples

      iex> update_promo_code(promo_code, %{field: new_value})
      {:ok, %Promo_code{}}

      iex> update_promo_code(promo_code, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_promo_code(%Promo_code{} = promo_code, attrs) do
    promo_code
    |> Promo_code.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Promo_code.

  ## Examples

      iex> delete_promo_code(promo_code)
      {:ok, %Promo_code{}}

      iex> delete_promo_code(promo_code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_promo_code(%Promo_code{} = promo_code) do
    Repo.delete(promo_code)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking promo_code changes.

  ## Examples

      iex> change_promo_code(promo_code)
      %Ecto.Changeset{source: %Promo_code{}}

  """
  def change_promo_code(%Promo_code{} = promo_code) do
    Promo_code.changeset(promo_code, %{})
  end

  def active_promocodes do
    query = from p in Promo_code, where: p.is_active == true
    Repo.all(query)
  end

  def is_valid?(%{"code" => code, "destination" => [lat, long], "origin" => origin})
      when is_bitstring(long) do
    radius = get_promo_code(code).radius
    Geocalc.within?(radius, to_float(origin), to_float([lat, long]))
  end

  def is_valid?(%{"code" => code, "destination" => dest, "origin" => origin}) do
    radius = get_promo_code(code).radius
    Geocalc.within?(radius, origin, dest)
  end

  defp to_float(value) when is_list(value) do
    value
    |> Enum.map(fn x -> String.to_float(x) end)
  end

  def get_polyline(%{"destination" => [lat, long], "origin" => origin}) when is_bitstring(lat) do
    [lat, long] = to_float([lat, long])
    [lat_a, long_b] = to_float(origin)
    Polyline.encode([{lat, long}, {lat_a, long_b}])
  end

  def get_polyline(%{"destination" => dest, "origin" => origin}) do
    Polyline.encode(dest, origin)
  end
end
