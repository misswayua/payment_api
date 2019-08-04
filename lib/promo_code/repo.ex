defmodule PromoCode.Repo do
  use Ecto.Repo,
    otp_app: :promo_code,
    adapter: Ecto.Adapters.Postgres
end
