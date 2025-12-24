defmodule Diplomacy.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string
      add :budget, :integer
      add :army_count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
