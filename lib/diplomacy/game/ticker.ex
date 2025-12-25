defmodule Diplomacy.Game.Ticker do
  @moduledoc """
  OTP GenServer that manages passive game progression.
  """
  use GenServer
  alias Diplomacy.Game
  alias Diplomacy.Game.SettingsCache
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{timer: nil, interval: nil}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    if Application.get_env(:diplomacy, :start_ticker, true) do
      # Subscribe to global game events
      Diplomacy.Game.subscribe()
      
      settings = SettingsCache.get()
      new_timer = schedule_tick(settings.passive_income_interval_ms)
      {:ok, %{state | timer: new_timer, interval: settings.passive_income_interval_ms}}
    else
      {:ok, state}
    end
  end

  @impl true
  def handle_info(:tick, state) do
    settings = SettingsCache.get()
    Game.process_passive_income(settings.passive_income_amount, settings.passive_income_happiness_inc)
    
    # Random event chance
    if settings.event_enabled && :rand.uniform(100) <= settings.event_probability do
      Game.trigger_random_event()
    end

    new_timer = schedule_tick(settings.passive_income_interval_ms)
    {:noreply, %{state | timer: new_timer, interval: settings.passive_income_interval_ms}}
  end

  @impl true
  def handle_info({:settings_updated, settings}, state) do
    # If the interval changed, reschedule immediately
    if settings.passive_income_interval_ms != state.interval do
      Logger.info("Ticker: Interval changed from #{state.interval} to #{settings.passive_income_interval_ms}. Rescheduling.")
      if state.timer, do: Process.cancel_timer(state.timer)
      
      new_timer = schedule_tick(settings.passive_income_interval_ms)
      {:noreply, %{state | timer: new_timer, interval: settings.passive_income_interval_ms}}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_info(_other, state), do: {:noreply, state}

  defp schedule_tick(interval) do
    Process.send_after(self(), :tick, interval)
  end
end