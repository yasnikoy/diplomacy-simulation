defmodule Diplomacy.Repo.Migrations.AddStartingParamsToSettings do
  use Ecto.Migration

  def change do
    alter table(:game_settings) do
      add :starting_budget, :integer, default: 500, null: false
      add :starting_army, :integer, default: 10, null: false
    end
  end
end
