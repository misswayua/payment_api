defmodule PromoCode.Repo.Migrations.CreatePromoCodes do
  use Ecto.Migration

  def change do
    create table(:promo_codes, primary_key: false) do
      add :code, :string, primary_key: true
      add :amount, :integer
      add :is_active, :boolean, default: true, null: false
      add :has_expired, :boolean, default: false, null: false
      add :radius, :float
      timestamps()
    end
  end
end
