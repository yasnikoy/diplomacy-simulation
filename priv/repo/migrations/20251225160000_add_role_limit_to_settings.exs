defmodule Diplomacy.Repo.Migrations.AddRoleLimitToSettings do
  use Ecto.Migration

  def change do
    alter table(:game_settings) do
      add :max_players_per_role, :integer, default: 3, null: false
    end
  end
end
