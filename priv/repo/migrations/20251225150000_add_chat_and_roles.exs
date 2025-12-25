defmodule Diplomacy.Repo.Migrations.AddChatAndRoles do
  use Ecto.Migration

  def change do
    # Ayarlara sohbet kontrolü ve roller ekle
    alter table(:game_settings) do
      add :chat_enabled, :boolean, default: true, null: false
      add :available_roles, :string, default: "Diplomat,Commander", null: false
    end

    # Mesajları saklamak için tablo
    create table(:chat_messages) do
      add :content, :text, null: false
      add :role, :string, null: false
      add :country_name, :string, null: false
      add :country_id, references(:countries, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:chat_messages, [:inserted_at])
  end
end
