defmodule DiplomacyWeb.HomeLive do
  use DiplomacyWeb, :live_view
  alias Diplomacy.Game

  def mount(_params, _session, socket) do
    if connected?(socket), do: Game.subscribe()
    {:ok, assign(socket, countries: Game.list_countries(), form: to_form(%{"name" => ""}))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-900 text-white p-4">
      <h1 class="text-4xl lg:text-5xl font-bold mb-8 lg:mb-12 text-emerald-400 text-center">Diplomacy</h1>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-12 w-full max-w-4xl">
        <!-- Join Existing -->
        <div class="bg-gray-800 p-6 lg:p-8 rounded-xl shadow-lg border border-gray-700">
          <h2 class="text-xl lg:text-2xl font-semibold mb-4 lg:mb-6">Join Existing Nation</h2>
          <div class="space-y-3 lg:space-y-4 max-h-64 overflow-y-auto pr-2 custom-scrollbar">
            <%= for country <- @countries do %>
              <.link navigate={~p"/game/#{country.id}"} class="block w-full text-left bg-gray-700 hover:bg-gray-600 p-3 lg:p-4 rounded-lg transition group">
                <div class="flex justify-between items-center">
                  <span class="font-bold group-hover:text-emerald-400 text-sm lg:text-base truncate max-w-[50%]"><%= country.name %></span>
                  <div class="text-xs lg:text-sm text-gray-400 flex gap-2 lg:gap-3">
                     <span><%= country.army_count %> ⚔️</span>
                     <span class="text-yellow-500"><%= country.budget %> 💰</span>
                  </div>
                </div>
              </.link>
            <% end %>
            <%= if Enum.empty?(@countries) do %>
              <p class="text-gray-500 text-center italic text-sm">No nations founded yet.</p>
            <% end %>
          </div>
        </div>

        <!-- Create New -->
        <div class="bg-gray-800 p-6 lg:p-8 rounded-xl shadow-lg border border-gray-700">
          <h2 class="text-xl lg:text-2xl font-semibold mb-4 lg:mb-6">Found New Nation</h2>
          <.form for={@form} phx-submit="create_country" class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-400 mb-1">Nation Name</label>
              <.input field={@form[:name]} placeholder="e.g. Cybertron" class="w-full bg-gray-700 border-gray-600 text-white focus:ring-emerald-500 focus:border-emerald-500 rounded-md text-sm lg:text-base p-2 lg:p-3" />
            </div>
            <button type="submit" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 px-4 rounded transition text-sm lg:text-base">
              Establish Nation
            </button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("create_country", %{"name" => name}, socket) do
    case Game.create_country(%{name: name, budget: 500, army_count: 10}) do
      {:ok, country} ->
        {:noreply, push_navigate(socket, to: ~p"/game/#{country.id}")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not create country. Name might be taken.")}
    end
  end

  def handle_info(:world_tick, socket) do
    {:noreply, assign(socket, countries: Game.list_countries())}
  end

  def handle_info({:country_created, country}, socket) do
    {:noreply, update(socket, :countries, fn countries -> [country | countries] end)}
  end

  def handle_info({:country_updated, updated_country}, socket) do
    # Update the country in the list if it exists
    {:noreply, update(socket, :countries, fn countries ->
      Enum.map(countries, fn c ->
        if c.id == updated_country.id, do: updated_country, else: c
      end)
    end)}
  end
end
