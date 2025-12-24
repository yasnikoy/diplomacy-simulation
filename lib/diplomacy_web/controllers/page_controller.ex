defmodule DiplomacyWeb.PageController do
  use DiplomacyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
