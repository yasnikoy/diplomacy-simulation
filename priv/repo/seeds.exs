# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Diplomacy.Repo.insert!(%Diplomacy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Diplomacy.Repo
alias Diplomacy.Game.Country

if Repo.aggregate(Country, :count) == 0 do
  Repo.insert!(%Country{
    name: "Gemini Republic",
    budget: 1000,
    army_count: 50
  })
end

if Repo.get_by(Country, name: "Borg Empire") == nil do
  Repo.insert!(%Country{
    name: "Borg Empire",
    budget: 5000,
    army_count: 2000
  })
end
