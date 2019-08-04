defmodule PromoCodeWeb.Promo_codeControllerTest do
  use PromoCodeWeb.ConnCase

  alias PromoCode.Promo_codes
  import PromoCode.Factory

  @create_attrs %{
    amount: 42,
    is_active: true,
    has_expired: false
  }

  @invalid_attrs %{amount: nil, code: nil, is_active: nil}

  def fixture(:promo_code) do
    {:ok, promo_code} = Promo_codes.create_promo_code(@create_attrs)
    promo_code
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all promo_codes", %{conn: conn} do
      promo_code = insert(:promo_code)

      assert [
               %{
                 "amount" => promo_code.amount,
                 "code" => promo_code.code,
                 "has_expired" => promo_code.has_expired,
                 "is_active" => promo_code.is_active
               }
             ] == decode(conn)
    end
  end

  describe "create promo_code" do
    test "renders promo_code when data is valid", %{conn: conn} do
      conn = post(conn, Routes.promo_code_path(conn, :create), promo_code: @create_attrs)

      [data] = decode(conn)
      assert data["amount"] == 42

      conn = get(conn, Routes.promo_code_path(conn, :show, data["code"]))

      assert %{
               "amount" => 42,
               "is_active" => true,
               "has_expired" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.promo_code_path(conn, :create), promo_code: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  test " show a promo code", %{conn: conn} do
    promo_code = insert(:promo_code)
    data = render_show_page(conn, promo_code)

    assert data == %{
             "amount" => promo_code.amount,
             "is_active" => promo_code.is_active,
             "code" => promo_code.code,
             "has_expired" => promo_code.has_expired
           }
  end

  test "promo_code can expire", %{conn: conn} do
    promo_code = insert(:promo_code)
    assert promo_code.has_expired == false
    %{resp_body: body} = post(conn, Routes.promo_code_path(conn, :expire, promo_code.code))
    %{"data" => data} = Jason.decode!(body)
    assert data["has_expired"] == true
  end

  test "promo_code can be deactivated", %{conn: conn} do
    promo_code = insert(:promo_code)
    assert promo_code.is_active == true
    %{resp_body: body} = post(conn, Routes.promo_code_path(conn, :deactivate, promo_code.code))
    %{"data" => data} = Jason.decode!(body)
    assert data["is_active"] == false
  end

  test "return all active promo_code", %{conn: conn} do
    promo_code_a = insert(:promo_code)
    promo_code_b = insert(:promo_code, code: "ghhxsjdsdsjsd", is_active: false)

    %{resp_body: body} =
      conn
      |> get(Routes.promo_code_path(conn, :active_promocodes))

    %{"data" => data} = Jason.decode!(body)

    assert data == [
             %{
               "amount" => promo_code_a.amount,
               "is_active" => promo_code_a.is_active,
               "code" => promo_code_a.code,
               "has_expired" => promo_code_a.has_expired
             }
           ]

    refute data == [
             %{
               "amount" => promo_code_b.amount,
               "is_active" => promo_code_b.is_active,
               "code" => promo_code_b.code,
               "has_expired" => promo_code_b.has_expired
             }
           ]
  end

  test "code is valid within the x radius of the event will return promo code and polyline", %{
    conn: conn
  } do
    promo_code = insert(:promo_code)

    %{resp_body: body} =
      conn
      |> post(
        Routes.promo_code_path(conn, :valid,
          attrs: %{
            code: promo_code.code,
            origin: ["2.0", "3.0"],
            destination: ["5.0", "7.0"]
          }
        )
      )

    %{"data" => data} = Jason.decode!(body)

    assert data == %{
             "amount" => promo_code.amount,
             "code" => promo_code.code,
             "has_expired" => promo_code.has_expired,
             "is_active" => promo_code.is_active,
             "polyline" => "_evi@_qo]~flW~|hQ"
           }
  end

  test "code is valid within the x radius of event will return error when user is not around x radius",
       %{
         conn: conn
       } do
    promo_code = insert(:promo_code, radius: 1.00)

    %{resp_body: body, status: status} =
      conn
      |> post(
        Routes.promo_code_path(conn, :valid,
          attrs: %{
            code: promo_code.code,
            origin: ["2.0", "3.0"],
            destination: ["5.0", "7.0"]
          }
        )
      )

    assert status == 404

    %{"errors" => error} = Jason.decode!(body)

    assert error == %{"detail" => "Not Found"}
  end

  test "update promo_code renders promo_code when data is valid", %{
    conn: conn
  } do
    promo_code = insert(:promo_code)
    attrs = %{@create_attrs | amount: 43, is_active: false}
    conn = put(conn, Routes.promo_code_path(conn, :update, promo_code), promo_code: attrs)

    conn = get(conn, Routes.promo_code_path(conn, :show, promo_code.code))

    assert %{
             "amount" => 43,
             # "code" => "MNTU",
             "is_active" => false
           } = json_response(conn, 200)["data"]
  end

  test "update promo_code renders errors when data is invalid", %{conn: conn} do
    promo_code = insert(:promo_code)

    conn =
      put(conn, Routes.promo_code_path(conn, :update, promo_code), promo_code: @invalid_attrs)

    assert json_response(conn, 404)["errors"] != %{}
  end

  # describe "delete promo_code" do
  #   setup [:create_promo_code]

  #   test "deletes chosen promo_code", %{conn: conn, promo_code: promo_code} do
  #     conn = delete(conn, Routes.promo_code_path(conn, :delete, promo_code))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.promo_code_path(conn, :show, promo_code))
  #     end
  #   end
  # end

  def create_promo_code(_) do
    promo_code = fixture(:promo_code)
    {:ok, promo_code: promo_code}
  end

  def decode(conn) do
    %{"data" => data} =
      conn
      |> get(Routes.promo_code_path(conn, :index))
      |> Map.get(:resp_body)
      |> Jason.decode!()

    data
  end

  def render_show_page(conn, promo_code) do
    %{resp_body: body} =
      conn
      |> get(Routes.promo_code_path(conn, :show, promo_code.code))

    %{"data" => data} = Jason.decode!(body)
    data
  end
end
