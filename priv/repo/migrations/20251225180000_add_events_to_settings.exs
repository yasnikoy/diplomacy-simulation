defmodule Diplomacy.Repo.Migrations.AddEventsToSettings do
  use Ecto.Migration

  def change do
    alter table(:game_settings) do
      add :event_enabled, :boolean, default: false
      add :event_probability, :integer, default: 5 # 5% chance per tick
    end
  end
end
