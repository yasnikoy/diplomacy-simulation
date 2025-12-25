defmodule Diplomacy.Game.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_messages" do
    field :content, :string
    field :role, :string
    field :country_name, :string
    field :country_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :role, :country_name, :country_id])
    |> validate_required([:content, :role, :country_name, :country_id])
    |> validate_length(:content, min: 1, max: 500)
  end
end
