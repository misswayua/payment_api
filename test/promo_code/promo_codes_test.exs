defmodule PromoCode.Promo_codesTest do
  use PromoCode.DataCase

  alias PromoCode.Promo_codes

  describe "promo_codes" do
    alias PromoCode.Promo_codes.Promo_code

    @valid_attrs %{"amount" => 42, "is_active" => true}
    @update_attrs %{"amount" => 43, "is_active" => false}
    @invalid_attrs %{"amount" => nil, "is_active" => nil}

    def promo_code_fixture(attrs \\ %{}) do
      {:ok, promo_code} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Promo_codes.create_promo_code()

      promo_code
    end

    test "list_promo_codes/0 returns all promo_codes" do
      promo_code = promo_code_fixture()
      assert Promo_codes.list_promo_codes() == [promo_code]
    end

    test "get_promo_code!/1 returns the promo_code with given promo_code" do
      promo_code = promo_code_fixture()
      assert Promo_codes.get_promo_code(promo_code.code) == promo_code
    end

    test "create_promo_code/1 with valid data creates a promo_code" do
      assert {:ok, %Promo_code{} = promo_code} = Promo_codes.create_promo_code(@valid_attrs)
      assert promo_code.amount == 42
      assert promo_code.is_active == true
    end

    test "create_promo_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Promo_codes.create_promo_code(@invalid_attrs)
    end

    test "update_promo_code/2 with valid data updates the promo_code" do
      promo_code = promo_code_fixture()

      assert {:ok, %Promo_code{} = promo_code} =
               Promo_codes.update_promo_code(promo_code, @update_attrs)

      assert promo_code.amount == 43
      assert promo_code.is_active == false
    end

    test "update_promo_code/2 with invalid data returns error changeset" do
      promo_code = promo_code_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Promo_codes.update_promo_code(promo_code, @invalid_attrs)

      assert promo_code == Promo_codes.get_promo_code(promo_code.code)
    end

    test "change_promo_code/1 returns a promo_code changeset" do
      promo_code = promo_code_fixture()
      assert %Ecto.Changeset{} = Promo_codes.change_promo_code(promo_code)
    end
  end
end
