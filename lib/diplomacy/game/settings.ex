defmodule Diplomacy.Game.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_settings" do
    field :soldier_cost, :integer, default: 10
    field :tax_amount, :integer, default: 100
    field :tax_happiness_penalty, :integer, default: 5
    field :passive_income_amount, :integer, default: 10
    field :passive_income_interval_ms, :integer, default: 5000
    field :attack_cost_gold, :integer, default: 100
    field :attack_cost_soldiers, :integer, default: 10
    field :attack_damage_min, :integer, default: 1
    field :attack_damage_max, :integer, default: 10
    field :attack_happiness_penalty_attacker, :integer, default: 5
    field :attack_happiness_penalty_defender, :integer, default: 10
    field :attack_defender_budget_multiplier, :integer, default: 20
    field :passive_income_happiness_inc, :integer, default: 1
    field :starting_budget, :integer, default: 500
    field :starting_army, :integer, default: 10
    field :chat_enabled, :boolean, default: true
    field :available_roles, :string, default: "Diplomat,Commander"
    field :max_players_per_role, :integer, default: 3
    field :admin_inject_amount, :integer, default: 1000

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [
      :soldier_cost,
      :tax_amount,
      :tax_happiness_penalty,
      :passive_income_amount,
      :passive_income_interval_ms,
      :attack_cost_gold,
      :attack_cost_soldiers,
      :attack_damage_min,
      :attack_damage_max,
      :attack_happiness_penalty_attacker,
      :attack_happiness_penalty_defender,
      :attack_defender_budget_multiplier,
      :passive_income_happiness_inc,
      :starting_budget,
      :starting_army,
      :chat_enabled,
      :available_roles,
      :max_players_per_role,
      :admin_inject_amount
    ])
    |> validate_required([
      :soldier_cost,
      :tax_amount,
      :tax_happiness_penalty,
      :passive_income_amount,
      :passive_income_interval_ms,
      :attack_cost_gold,
      :attack_cost_soldiers,
      :attack_damage_min,
      :attack_damage_max,
      :attack_happiness_penalty_attacker,
      :attack_happiness_penalty_defender,
      :attack_defender_budget_multiplier,
      :passive_income_happiness_inc,
      :starting_budget,
      :starting_army,
      :chat_enabled,
      :available_roles,
      :max_players_per_role,
      :admin_inject_amount
    ])
    |> validate_number(:soldier_cost, greater_than_or_equal_to: 0)
    |> validate_number(:passive_income_interval_ms, greater_than_or_equal_to: 100) # Minimum 100ms to prevent crash
    |> validate_number(:attack_damage_min, greater_than_or_equal_to: 0)
    |> validate_number(:attack_damage_max, greater_than: 0)
    |> validate_damage_range()
  end

  defp validate_damage_range(changeset) do
    min = get_field(changeset, :attack_damage_min)
    max = get_field(changeset, :attack_damage_max)

    if min && max && min > max do
      add_error(changeset, :attack_damage_min, "must be less than or equal to max damage")
    else
      changeset
    end
  end
end
