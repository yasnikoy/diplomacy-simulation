defmodule DiplomacyWeb.CountryLiveTest do
  use DiplomacyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Diplomacy.GameFixtures

  test "disconnected and connected render", %{conn: conn} do
    country = country_fixture(name: "Testopia", budget: 500, army_count: 100, happiness: 100)
    
    {:ok, index_live, html} = live(conn, ~p"/game/#{country.id}")

    assert html =~ "Command Center"
    assert html =~ "Testopia"
    assert html =~ "💰</span> 500"
    assert html =~ "Morale"
    assert html =~ "🙂"
    assert html =~ "World Powers"
  end

  test "collect tax updates budget and morale", %{conn: conn} do
    country = country_fixture(name: "TaxLand", budget: 0, happiness: 50)
    {:ok, index_live, _html} = live(conn, ~p"/game/#{country.id}")

    assert index_live |> element("button", "Collect Taxes") |> render_click() =~ "💰</span> 100"
    # Morale goes down
    assert render(index_live) =~ "45%"
  end

  test "recruit soldier updates army and budget", %{conn: conn} do
    country = country_fixture(name: "ArmyLand", budget: 100, army_count: 0)
    {:ok, index_live, _html} = live(conn, ~p"/game/#{country.id}")

    html = index_live |> element("button", "Recruit Soldier") |> render_click()
    
    assert html =~ "💰</span> 90"
    assert html =~ "⚔️</span> 1"
  end

  test "cannot recruit soldier without budget", %{conn: conn} do
    country = country_fixture(name: "PoorLand", budget: 0, army_count: 0)
    {:ok, index_live, _html} = live(conn, ~p"/game/#{country.id}")

    index_live |> element("button", "Recruit Soldier") |> render_click()
    
    assert render(index_live) =~ "Not enough budget"
  end

  test "updates when other country changes", %{conn: conn} do
    # This tests the PubSub functionality
    country = country_fixture(name: "RivalNation", army_count: 50)
    {:ok, index_live, _html} = live(conn, ~p"/game/#{country.id}")

    assert render(index_live) =~ "RivalNation"
    assert render(index_live) =~ "50 ⚔️"

    # Simulate update from another process
    Diplomacy.Game.update_country(country, %{army_count: 100})

    # The view should update automatically via PubSub
    assert render(index_live) =~ "100 ⚔️"
  end

  test "attack enemy functionality", %{conn: conn} do
    attacker = country_fixture(name: "Attacker", budget: 2000, army_count: 100)
    defender = country_fixture(name: "Defender", budget: 500, army_count: 50)
    
    {:ok, index_live, _html} = live(conn, ~p"/game/#{attacker.id}")

    # Find the attack button for Defender
    # Since I don't see budget in leaderboard anymore (if I removed it), I check for attack button.
    
    html = index_live |> element("button[phx-value-target-id='#{defender.id}']", "ATTACK") |> render_click()

    assert html =~ "Attack Successful"
    # Attacker lost 100 gold
    assert html =~ "💰</span> 1900"
    # Attacker lost 10 soldiers
    assert html =~ "⚔️</span> 90"
  end

  test "updates when new country is created", %{conn: conn} do
    country = country_fixture(name: "MyNation")
    {:ok, index_live, _html} = live(conn, ~p"/game/#{country.id}")

    refute render(index_live) =~ "NewChallenger"

    # Simulate creation from another process
    Diplomacy.Game.create_country(%{name: "NewChallenger", budget: 500, army_count: 10})

    assert render(index_live) =~ "NewChallenger"
  end
end
