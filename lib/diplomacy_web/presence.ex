defmodule DiplomacyWeb.Presence do
  use Phoenix.Presence,
    otp_app: :diplomacy,
    pubsub_server: Diplomacy.PubSub
end
