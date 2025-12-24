defmodule Diplomacy.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Diplomacy.Game` context.
  """

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        name: "some name",
        budget: 42,
        army_count: 42,
        happiness: 100
      })
      |> Diplomacy.Game.create_country()

    country
  end
end
