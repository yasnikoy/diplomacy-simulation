defmodule Diplomacy.Game do
  @moduledoc """
  The Game context.
  Handles business logic for nations, resources, and combat.
  """

  import Ecto.Query, warn: false
  alias Diplomacy.Repo
  alias Diplomacy.Game.Country

  @doc """
  Returns the list of countries.
  """
  @spec list_countries() :: [Country.t()]
  def list_countries do
    Repo.all(from c in Country, order_by: [desc: c.army_count])
  end

  @doc """
  Gets a single country.
  """
  @spec get_country!(integer() | String.t()) :: Country.t()
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.
  """
  @spec create_country(map()) :: {:ok, Country.t()} | {:error, Ecto.Changeset.t()}
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
    |> broadcast({:country_created})
  end

  @doc """
  Updates a country.
  """
  @spec update_country(Country.t(), map()) :: {:ok, Country.t()} | {:error, Ecto.Changeset.t()}
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
    |> broadcast({:country_updated})
  end

  @doc """
  Collects taxes: +Budget, -Morale.
  """
  @spec collect_tax(Country.t(), integer()) :: {:ok, Country.t()} | {:error, any()}
  def collect_tax(%Country{} = country, amount) when amount > 0 do
    update_country(country, %{
      budget: country.budget + amount,
      happiness: max(0, country.happiness - 5)
    })
  end

  @doc """
  Recruits soldiers: -Budget, +Army.
  """
  @spec recruit_soldiers(Country.t(), integer()) :: {:ok, Country.t()} | {:error, String.t()}
  def recruit_soldiers(%Country{} = country, count) when count > 0 do
    cost = count * 10

    if country.budget >= cost do
      update_country(country, %{
        budget: country.budget - cost,
        army_count: country.army_count + count
      })
    else
      {:error, "Not enough budget"}
    end
  end

  @doc """
  Declares war on a target country using a transaction.
  """
  @spec declare_war(Country.t(), integer()) :: {:ok, map()} | {:error, any()}
  def declare_war(%Country{} = attacker, defender_id) do
    Repo.transaction(fn ->
      with defender <- get_country!(defender_id),
           :ok <- check_war_resources(attacker, defender),
           {:ok, up_attacker} <- apply_attacker_penalty(attacker),
           {:ok, up_defender} <- apply_defender_penalty(defender) do
        
        Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", {:attacked, defender.id})
        %{attacker: up_attacker, defender: up_defender}
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp check_war_resources(a, d) do
    cond do
      a.id == d.id -> {:error, "Cannot attack yourself"}
      a.army_count < 10 or a.budget < 100 -> {:error, "Not enough resources"}
      true -> :ok
    end
  end

  defp apply_attacker_penalty(a) do
    update_country(a, %{
      army_count: a.army_count - 10,
      budget: a.budget - 100,
      happiness: max(0, a.happiness - 5)
    })
  end

  defp apply_defender_penalty(d) do
    update_country(d, %{
      army_count: max(0, d.army_count - 5),
      budget: max(0, d.budget - 200),
      happiness: max(0, d.happiness - 10)
    })
  end

  @doc """
  Bulk update for passive income to optimize DB performance.
  """
  @spec process_passive_income(integer(), integer()) :: {integer(), nil}
  def process_passive_income(budget_inc, happiness_inc) do
    # 1. Update database in one query
    # Note: happiness is capped at 100 in the query logic
    query = from c in Country,
            update: [
              inc: [budget: ^budget_inc],
              set: [happiness: fragment("LEAST(100, happiness + ?)", ^happiness_inc)]
            ]
    
    result = Repo.update_all(query, [])
    
    # 2. Broadcast a global tick to tell LiveViews to refresh their lists
    # This is more efficient than broadcasting 100 individual country updates.
    Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", :world_tick)
    
    result
  end

  @spec subscribe() :: :ok | {:error, term()}
  def subscribe do
    Phoenix.PubSub.subscribe(Diplomacy.PubSub, "game:global")
  end

  defp broadcast({:ok, country}, event_tuple) do
    # Extract the dynamic part of the event
    event = Tuple.append(event_tuple, country)
    Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", event)
    {:ok, country}
  end
  defp broadcast(error, _), do: error
end
