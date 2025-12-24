defmodule DiplomacyWeb.HomeLiveTest do
  use DiplomacyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Diplomacy.GameFixtures

  test "connected mount shows creation form and existing nations", %{conn: conn} do
    country = country_fixture(name: "ExistingLand")
    {:ok, index_live, html} = live(conn, "/")

    assert html =~ "Found New Nation"
    assert html =~ "ExistingLand"
  end

  test "can create a new nation", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, "/")

    {:ok, _view, html} =
      index_live
      |> form("form", %{"name" => "NewRepublic"})
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "NewRepublic"
    assert html =~ "Command Center"
  end
end
