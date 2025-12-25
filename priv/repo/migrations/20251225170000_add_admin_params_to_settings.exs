defmodule Diplomacy.Repo.Migrations.AddAdminParamsToSettings do
  use Ecto.Migration

  def change do
    alter table(:game_settings) do
      add :admin_inject_amount, :integer, default: 1000, null: false
    end
  end
end
