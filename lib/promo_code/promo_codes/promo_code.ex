defmodule PromoCode.Promo_codes.Promo_code do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :code}
  @primary_key {:code, :string, autogenerate: false}
  schema "promo_codes" do
    field :amount, :integer
    field :is_active, :boolean, default: true
    field :has_expired, :boolean, default: false
    field :radius, :float
    timestamps()
  end

  @doc false
  def changeset(promo_code, attrs) do
    promo_code
    |> cast(attrs, [:code, :amount, :is_active, :has_expired, :radius])
    |> validate_required([:amount, :is_active, :has_expired])
  end
end
