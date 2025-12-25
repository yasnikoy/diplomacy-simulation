defmodule Diplomacy.Game.Ticker do
  @moduledoc """
  OTP GenServer that manages passive game progression.
  """
  use GenServer
  alias Diplomacy.Game
  alias Diplomacy.Game.SettingsCache
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    if Application.get_env(:diplomacy, :start_ticker, true) do
      settings = SettingsCache.get()
      schedule_tick(settings.passive_income_interval_ms)
    end
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, state) do
    settings = SettingsCache.get()
    Game.process_passive_income(settings.passive_income_amount, settings.passive_income_happiness_inc)
    
    schedule_tick(settings.passive_income_interval_ms)
    {:noreply, state}
  end

  defp schedule_tick(interval) do
    Process.send_after(self(), :tick, interval)
  end
end