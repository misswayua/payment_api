defmodule PromoCodeWeb.Promo_codeController do
  use PromoCodeWeb, :controller

  alias PromoCode.Promo_codes
  alias PromoCode.Promo_codes.Promo_code
  alias PromoCodeWeb.ErrorView
  action_fallback PromoCodeWeb.FallbackController

  def index(conn, _params) do
    promo_codes = Promo_codes.list_promo_codes()
    render(conn, "index.json", promo_codes: promo_codes)
  end

  def create(conn, %{"promo_code" => promo_code_params}) do
    with {:ok, %Promo_code{} = promo_code} <- Promo_codes.create_promo_code(promo_code_params) do
      conn
      |> put_status(:created)
      |> render_promo_code(promo_code)
    else
      {:error, %{errors: errors}} ->
        conn
        |> put_status(422)
        |> render(ErrorView, "422.json", %{errors: errors})
    end
  end

  def show(conn, %{"id" => code}) do
    with promo_code = %Promo_code{} <- Promo_codes.get_promo_code(code) do
      render(conn, "show.json", promo_code: promo_code)
    else
      nil ->
        render_error(conn)
    end
  end

  def update(conn, %{"id" => code, "promo_code" => params}) do
    with promo_code = %Promo_code{} <- Promo_codes.get_promo_code(code) do
      case Promo_codes.update_promo_code(promo_code, params) do
        {:ok, promo_code} ->
          conn |> render_promo_code(promo_code)

        _ ->
          render_error(conn)
      end
    else
      nil ->
        render_error(conn)
    end
  end

  def expire(conn, %{"id" => code}) do
    with promo_code = %Promo_code{} <- Promo_codes.get_promo_code(code) do
      {:ok, promo_code} = Promo_codes.update_promo_code(promo_code, %{has_expired: true})
      conn |> render_promo_code(promo_code)
    else
      nil ->
        render_error(conn)
    end
  end

  def deactivate(conn, %{"id" => code}) do
    with promo_code = %Promo_code{} <- Promo_codes.get_promo_code(code) do
      {:ok, promo_code} = Promo_codes.update_promo_code(promo_code, %{is_active: false})

      conn |> render_promo_code(promo_code)
    else
      nil ->
        render_error(conn)
    end
  end

  def active_promocodes(conn, _params) do
    promo_codes = Promo_codes.active_promocodes()
    render(conn, "index.json", promo_codes: promo_codes)
  end

  def valid(conn, %{"attrs" => params}) do
    IO.inspect params
    case Promo_codes.is_valid?(params) do
      true ->
        promo_code = Promo_codes.get_promo_code(params["code"])
        polyline = Promo_codes.get_polyline(params)

        conn
        |> put_resp_header("location", Routes.promo_code_path(conn, :show, promo_code))
        |> render("valid.json", promo_code: {promo_code, polyline})

      false ->
        conn
        |> render_error()
    end
  end

  def render_error(conn) do
    conn
    |> put_status(404)
    |> render(ErrorView, "404.json", error: "Not Found")
  end

  def render_promo_code(conn, promo_code) do
    conn
    |> put_resp_header("location", Routes.promo_code_path(conn, :show, promo_code))
    |> render("show.json", promo_code: promo_code)
  end
end
