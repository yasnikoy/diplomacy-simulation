defmodule Diplomacy.Game.SettingsCache do
  use GenServer
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
    :ets.new(@table, [:set, :protected, :named_table])
    fetch_and_cache()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:update, attrs}, _from, state) do
    settings = load_settings_from_db()

    case Settings.changeset(settings, attrs) |> Repo.update() do
      {:ok, updated_settings} ->
        :ets.insert(@table, {@key, updated_settings})
        # Broadcast that settings changed
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
    settings = Repo.one(Settings) || %Settings{} |> Repo.insert!()

    # Identify fields that are currently nil but should have values
    # We use the changeset to apply defaults if we find nils
    if has_nil_fields?(settings) do
      settings
      |> Settings.changeset(%{}) # Changeset will use default values from schema for nils
      |> Repo.update!()
    else
      settings
    end
  end

  defp has_nil_fields?(settings) do
    settings
    |> Map.from_struct()
    |> Map.drop([:id, :inserted_at, :updated_at, :__meta__])
    |> Enum.any?(fn {_, v} -> is_nil(v) end)
  end
end
