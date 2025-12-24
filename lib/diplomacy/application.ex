defmodule Diplomacy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DiplomacyWeb.Telemetry,
      Diplomacy.Repo,
      {DNSCluster, query: Application.get_env(:diplomacy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Diplomacy.PubSub},
      # Start to serve requests, typically the last entry
      DiplomacyWeb.Endpoint
    ]

    # Conditionally add Ticker
    children = 
      if Application.get_env(:diplomacy, :start_ticker, true) do
        children ++ [Diplomacy.Game.Ticker]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Diplomacy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DiplomacyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
