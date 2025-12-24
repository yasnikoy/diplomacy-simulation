defmodule Diplomacy.Game.Ticker do
  @moduledoc """
  OTP GenServer that manages passive game progression.
  """
  use GenServer
  alias Diplomacy.Game
  require Logger

  @interval 5000 
  @budget_inc 10
  @happiness_inc 1

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    if Application.get_env(:diplomacy, :start_ticker, true) do
      schedule_tick()
    end
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, state) do
    Game.process_passive_income(@budget_inc, @happiness_inc)
    schedule_tick()
    {:noreply, state}
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, @interval)
  end
end