defmodule Diplomacy.Repo.Migrations.AddHappinessToCountries do
  use Ecto.Migration

  def change do
    alter table(:countries) do
      add :happiness, :integer, default: 100, null: false
    end
  end
end