defmodule PromoCodeWeb.Promo_codeView do
  use PromoCodeWeb, :view
  alias PromoCodeWeb.Promo_codeView

  def render("index.json", %{promo_codes: promo_codes}) do
    %{data: render_many(promo_codes, Promo_codeView, "promo_code.json")}
  end

  def render("show.json", %{promo_code: promo_code}) do
    %{data: render_one(promo_code, Promo_codeView, "promo_code.json")}
  end

  def render("promo_code.json", %{promo_code: promo_code}) do
    %{
      code: promo_code.code,
      amount: promo_code.amount,
      is_active: promo_code.is_active,
      has_expired: promo_code.has_expired,
      radius: promo_code.radius
    }
  end

  def render("valid.json", %{promo_code: promo_code}) do
    %{data: render_one(promo_code, Promo_codeView, "promo.json")}
  end

  def render("promo.json", %{promo_code: {promo_code, polyline}}) do
    %{
      code: promo_code.code,
      amount: promo_code.amount,
      is_active: promo_code.is_active,
      has_expired: promo_code.has_expired,
      radius: promo_code.radius,
      polyline: polyline
    }
  end
end
