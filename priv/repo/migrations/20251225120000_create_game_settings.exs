defmodule Diplomacy.Repo.Migrations.CreateGameSettings do
  use Ecto.Migration

  def change do
    create table(:game_settings) do
      add :soldier_cost, :integer, default: 10, null: false
      add :tax_amount, :integer, default: 100, null: false
      add :tax_happiness_penalty, :integer, default: 5, null: false
      add :passive_income_amount, :integer, default: 10, null: false
      add :passive_income_interval_ms, :integer, default: 5000, null: false
      add :attack_cost_gold, :integer, default: 100, null: false
      add :attack_cost_soldiers, :integer, default: 10, null: false
      add :attack_damage_min, :integer, default: 1, null: false
      add :attack_damage_max, :integer, default: 10, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
