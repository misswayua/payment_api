defmodule PromoCode.Factory do
  alias PromoCode.Promo_codes.Promo_code
  alias PromoCode.Repo

  def create(:promo_code) do
    %Promo_code{
      code: "MNRTGYHU-GTHNGHJH",
      amount: 20,
      is_active: true,
      has_expired: false,
      radius: 17_000_000.0
    }
  end

  def create(factory_name, attrs) do
    factory_name
    |> create()
    |> struct(attrs)
  end

  @doc """
   Insert a new promo code record into the database
  """
  @spec insert(atom(), list) :: map
  def insert(factory_name, attrs \\ []) do
    Repo.insert!(create(factory_name, attrs))
  end
end
