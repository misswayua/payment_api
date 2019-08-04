defmodule PromoCodeWeb.Router do
  use PromoCodeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PromoCodeWeb do
    pipe_through :api
    post "/promo_codes/valid", Promo_codeController, :valid
    get "/promo_codes/active_promocodes", Promo_codeController, :active_promocodes
    resources "/promo_codes", Promo_codeController, only: [:create, :show, :index, :update]
    post "/promo_codes/expire/:id", Promo_codeController, :expire
    post "/promo_codes/deactivate/:id", Promo_codeController, :deactivate
  end
end
