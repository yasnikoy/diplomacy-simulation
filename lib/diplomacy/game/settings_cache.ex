defmodule Diplomacy.Game.SettingsCache do
  use GenServer
  import Ecto.Query
  alias Diplomacy.Repo
  alias Diplomacy.Game.Settings

  @table :game_settings_cache
  @key :current_settings

  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Returns the current game settings struct from cache (ETS).
  """
  @spec get() :: Settings.t()
  def get do
    case :ets.lookup(@table, @key) do
      [{@key, settings}] -> settings
      [] -> 
        # Fallback if cache is empty (should not happen after init)
        fetch_and_cache()
    end
  end

  @doc """
  Updates the settings in DB and Cache.
  """
  @spec update(map()) :: {:ok, Settings.t()} | {:error, Ecto.Changeset.t()}
  def update(attrs) do
    GenServer.call(__MODULE__, {:update, attrs})
  end

  # Server Callbacks

  @impl true
  def init(_state) do
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true])
    fetch_and_cache()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:update, attrs}, _from, state) do
    settings = get() # Get current from ETS

    case Settings.changeset(settings, attrs) |> Repo.update() do
      {:ok, updated_settings} ->
        :ets.insert(@table, {@key, updated_settings})
        Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", {:settings_updated, updated_settings})
        {:reply, {:ok, updated_settings}, state}

      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  defp fetch_and_cache do
    settings = load_settings_from_db()
    :ets.insert(@table, {@key, settings})
    settings
  end

  defp load_settings_from_db do
    # Her zaman ilk kaydı al, yoksa oluştur. 
    # Bu sayede DB'de birden fazla satır olsa bile tutarlılık sağlanır.
    case Repo.all(from s in Settings, limit: 1) do
      [settings] ->
        settings

      [] ->
        %Settings{}
        |> Settings.changeset(%{
          starting_budget: 500,
          starting_army: 10,
          admin_inject_amount: 1000,
          passive_income_amount: 10,
          passive_income_interval_ms: 5000,
          passive_income_happiness_inc: 1,
          event_enabled: false,
          event_probability: 5
        })
        |> Repo.insert!()
    end
  end
end
