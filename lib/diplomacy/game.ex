defmodule Diplomacy.Game do
  @moduledoc """
  The Game context.
  Handles business logic for nations, resources, and combat.
  """

  import Ecto.Query, warn: false
  alias Diplomacy.Repo
  alias Diplomacy.Game.{Country, SettingsCache, ChatMessage}

  @doc """
  Lists the last 50 chat messages.
  """
  def list_recent_messages(limit \\ 50) do
    Repo.all(from m in ChatMessage, order_by: [asc: m.inserted_at], limit: ^limit)
  end

  @doc """
  Sends a chat message and broadcasts it.
  """
  def send_chat_message(attrs) do
    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", {:new_chat_message, message})
        {:ok, message}
      error -> error
    end
  end

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
  Deletes a country.
  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
    Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", :world_tick)
  end

  @doc """
  Collects taxes: +Budget, -Morale. Uses dynamic settings.
  """
  @spec collect_tax(Country.t()) :: {:ok, Country.t()} | {:error, any()}
  def collect_tax(%Country{} = country) do
    settings = SettingsCache.get()
    
    update_country(country, %{
      budget: country.budget + settings.tax_amount,
      happiness: max(0, country.happiness - settings.tax_happiness_penalty)
    })
  end

  @doc """
  Recruits soldiers: -Budget, +Army. Uses dynamic settings.
  """
  @spec recruit_soldiers(Country.t(), integer()) :: {:ok, Country.t()} | {:error, String.t()}
  def recruit_soldiers(%Country{} = country, count) when count > 0 do
    settings = SettingsCache.get()
    cost = count * settings.soldier_cost

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
  Declares war on a target country using a transaction. Uses dynamic settings.
  """
  @spec declare_war(Country.t(), integer()) :: {:ok, map()} | {:error, any()}
  def declare_war(%Country{} = attacker, defender_id) do
    settings = SettingsCache.get()
    
    Repo.transaction(fn ->
      with defender when not is_nil(defender) <- Repo.get(Country, defender_id),
           :ok <- check_war_resources(attacker, defender, settings),
           {:ok, up_attacker} <- apply_attacker_penalty(attacker, settings),
           {:ok, up_defender} <- apply_defender_penalty(defender, settings) do
        
        Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", {:attacked, defender.id})
        %{attacker: up_attacker, defender: up_defender}
      else
        nil -> Repo.rollback("Defender not found")
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp check_war_resources(a, d, s) do
    cond do
      a.id == d.id -> {:error, "Cannot attack yourself"}
      a.army_count < s.attack_cost_soldiers or a.budget < s.attack_cost_gold -> 
        {:error, "Not enough resources"}
      true -> :ok
    end
  end

  defp apply_attacker_penalty(a, s) do
    update_country(a, %{
      army_count: a.army_count - s.attack_cost_soldiers,
      budget: a.budget - s.attack_cost_gold,
      happiness: max(0, a.happiness - s.attack_happiness_penalty_attacker)
    })
  end

  defp apply_defender_penalty(d, s) do
    # Damage calculation based on settings range
    damage = Enum.random(s.attack_damage_min..s.attack_damage_max)
    
    update_country(d, %{
      army_count: max(0, d.army_count - damage),
      budget: max(0, d.budget - (damage * s.attack_defender_budget_multiplier)),
      happiness: max(0, d.happiness - s.attack_happiness_penalty_defender)
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

  @doc """
  Triggers a random global event based on a predefined list.
  """
  @spec trigger_random_event() :: :ok | {:error, String.t()}
  def trigger_random_event do
    events = [
      %{
        title: "Global Economic Boom",
        description: "A sudden rise in global trade! All nations receive +200 gold.",
        effect: fn -> 
          from(c in Country, update: [inc: [budget: 200]]) |> Repo.update_all([])
        end
      },
      %{
        title: "Stock Market Crash",
        description: "Financial crisis hit the world! All nations lose 150 gold.",
        effect: fn -> 
          from(c in Country, update: [set: [budget: fragment("GREATEST(0, budget - 150)")]]) |> Repo.update_all([])
        end
      },
      %{
        title: "Peace Festival",
        description: "People are celebrating! Happiness increases by 15 across the globe.",
        effect: fn -> 
          from(c in Country, update: [set: [happiness: fragment("LEAST(100, happiness + 15)")]]) |> Repo.update_all([])
        end
      },
      %{
        title: "Military Coup Attempt",
        description: "Unrest in the barracks! Random nation loses 30% of its army.",
        effect: fn -> 
          case Repo.all(from c in Country, order_by: fragment("RANDOM()"), limit: 1) do
            [c] -> 
              reduction = round(c.army_count * 0.3)
              update_country(c, %{army_count: c.army_count - reduction})
            [] -> :ok
          end
        end
      }
    ]

    event = Enum.random(events)
    event.effect.()
    
    Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", {:global_event, event})
    :ok
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
