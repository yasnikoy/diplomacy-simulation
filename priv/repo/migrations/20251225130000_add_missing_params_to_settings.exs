defmodule Diplomacy.Repo.Migrations.AddMissingParamsToSettings do
  use Ecto.Migration

  def change do
    alter table(:game_settings) do
      add :attack_happiness_penalty_attacker, :integer, default: 5, null: false
      add :attack_happiness_penalty_defender, :integer, default: 10, null: false
      add :attack_defender_budget_multiplier, :integer, default: 20, null: false
      add :passive_income_happiness_inc, :integer, default: 1, null: false
    end
  end
end
