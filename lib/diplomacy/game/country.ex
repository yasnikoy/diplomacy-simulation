defmodule Diplomacy.Game.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :name, :string
    field :budget, :integer, default: 0
    field :army_count, :integer, default: 0
    field :happiness, :integer, default: 100

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :budget, :army_count, :happiness])
    |> validate_required([:name])
    |> validate_number(:budget, greater_than_or_equal_to: 0)
    |> validate_number(:army_count, greater_than_or_equal_to: 0)
    |> validate_number(:happiness, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
  end
end
