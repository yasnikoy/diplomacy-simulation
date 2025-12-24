defmodule DiplomacyWeb.CountryLive do
  use DiplomacyWeb, :live_view
  alias Diplomacy.Game

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Game.subscribe()

    countries = Game.list_countries()
    
    # Find the requested country, handle case where it doesn't exist (e.g. invalid ID)
    current_country = Enum.find(countries, fn c -> to_string(c.id) == id end)

    if current_country do
      socket =
        socket
        |> assign(:countries, countries)
        |> assign(:country, current_country)
      {:ok, socket}
    else
      {:ok, push_navigate(socket, to: ~p"/")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row items-start justify-center h-full p-4 lg:p-8 gap-8 bg-gray-900 min-h-screen">
      <!-- Player Control Panel -->
      <div class="flex flex-col items-center space-y-6 lg:space-y-8 w-full lg:w-1/3">
        <h1 class="text-3xl lg:text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-cyan-500 drop-shadow-md text-center">
          Command Center
        </h1>

        <%= if @country do %>
          <div class="bg-gray-800 p-6 lg:p-8 rounded-2xl shadow-2xl border border-gray-700 w-full max-w-md relative overflow-hidden group">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 to-blue-500"></div>
            
            <h2 class="text-2xl lg:text-3xl font-bold mb-6 lg:mb-8 text-center text-white tracking-wide truncate"><%= @country.name %></h2>
            
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 lg:gap-6 mb-6 lg:mb-8">
              <div class="flex flex-row sm:flex-col justify-between sm:justify-center items-center p-3 lg:p-4 bg-gray-700/50 rounded-xl border border-gray-600">
                <span class="text-gray-400 text-xs lg:text-sm uppercase tracking-wider mb-0 sm:mb-1">Budget</span>
                <span id="budget-counter" phx-hook="RollingNumber" data-type="budget" class="text-lg lg:text-2xl font-mono text-yellow-400 font-bold flex items-center gap-2 transition-colors">
                  <span class="text-xl lg:text-3xl">💰</span> <%= @country.budget %>
                </span>
              </div>
              
              <div class="flex flex-row sm:flex-col justify-between sm:justify-center items-center p-3 lg:p-4 bg-gray-700/50 rounded-xl border border-gray-600">
                <span class="text-gray-400 text-xs lg:text-sm uppercase tracking-wider mb-0 sm:mb-1">Army</span>
                <span id="army-counter" phx-hook="RollingNumber" data-type="army" class="text-lg lg:text-2xl font-mono text-red-400 font-bold flex items-center gap-2 transition-colors">
                  <span class="text-xl lg:text-3xl">⚔️</span> <%= @country.army_count %>
                </span>
              </div>

              <div class="flex flex-row sm:flex-col justify-between sm:justify-center items-center p-3 lg:p-4 bg-gray-700/50 rounded-xl border border-gray-600">
                <span class="text-gray-400 text-xs lg:text-sm uppercase tracking-wider mb-0 sm:mb-1">Morale</span>
                <span class="text-lg lg:text-2xl font-mono text-blue-400 font-bold flex items-center gap-2">
                  <span class="text-xl lg:text-3xl">
                    <%= if @country.happiness > 70, do: "🙂", else: (if @country.happiness > 30, do: "😐", else: "😠") %>
                  </span> 
                  <%= @country.happiness %>%
                </span>
              </div>
            </div>

            <div class="space-y-3 lg:space-y-4">
              <button phx-click="collect_tax" class="w-full group relative overflow-hidden bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3 lg:py-4 px-4 lg:px-6 rounded-xl transition duration-300 shadow-lg hover:shadow-emerald-500/20 active:scale-95 text-sm lg:text-base">
                <div class="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/10 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></div>
                <div class="flex items-center justify-center gap-2">
                  <span>💰</span> <span>Collect Taxes (+100, -5 🙂)</span>
                </div>
              </button>
              
              <button phx-click="recruit_soldier" class="w-full group relative overflow-hidden bg-red-600 hover:bg-red-500 text-white font-bold py-3 lg:py-4 px-4 lg:px-6 rounded-xl transition duration-300 shadow-lg hover:shadow-red-500/20 active:scale-95 text-sm lg:text-base">
                 <div class="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/10 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></div>
                <div class="flex items-center justify-center gap-2">
                  <span>⚔️</span> <span>Recruit Soldier (Cost: 10)</span>
                </div>
              </button>
            </div>
          </div>
        <% else %>
          <div class="bg-red-500/10 border border-red-500 text-red-500 p-4 rounded-lg">
            No country found! Please run seeds.
          </div>
        <% end %>
        
        <div class="mt-4">
           <.link navigate={~p"/"} class="text-gray-400 hover:text-white underline decoration-gray-600 hover:decoration-white underline-offset-4 transition">
             &larr; Return to Lobby
           </.link>
        </div>
      </div>

      <!-- Global Leaderboard -->
      <div class="w-full lg:w-1/3 flex flex-col h-[500px] lg:h-[600px]">
        <h2 class="text-2xl lg:text-3xl font-bold text-blue-400 mb-4 lg:mb-6 text-center flex items-center justify-center gap-2">
          <span>🌍</span> World Powers
        </h2>
        <div class="bg-gray-800 rounded-xl shadow-xl border border-gray-700 overflow-hidden flex-1 flex flex-col">
          <div class="overflow-x-auto overflow-y-auto flex-1 custom-scrollbar">
            <table class="w-full text-left min-w-[300px]">
              <thead class="bg-gray-700 text-gray-300 sticky top-0 z-10 shadow-md">
                <tr>
                  <th class="p-3 lg:p-4 font-semibold tracking-wider text-sm lg:text-base">Nation</th>
                  <th class="p-3 lg:p-4 text-right font-semibold tracking-wider text-sm lg:text-base">Army</th>
                  <th class="p-3 lg:p-4 text-right font-semibold tracking-wider text-sm lg:text-base">Action</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-700/50">
                <%= for c <- Enum.sort_by(@countries, &(&1.army_count), :desc) do %>
                  <tr class={"transition-colors duration-200 " <> if @country && c.id == @country.id, do: "bg-emerald-900/20 hover:bg-emerald-900/30", else: "hover:bg-gray-750"}>
                    <td class="p-3 lg:p-4 font-semibold text-white flex items-center gap-2 text-sm lg:text-base">
                      <%= if @country && c.id == @country.id, do: "🚩", else: "" %>
                      <%= c.name %>
                    </td>
                    <td class="p-3 lg:p-4 text-right font-mono text-red-300 text-sm lg:text-base"><%= c.army_count %> ⚔️</td>
                    <td class="p-3 lg:p-4 text-right">
                      <%= if @country && c.id != @country.id do %>
                        <button phx-click="attack" phx-value-target-id={c.id} class="bg-red-700 hover:bg-red-600 text-white text-xs font-bold py-1 px-2 rounded transition" title="Cost: 10 Army, 100 Gold">
                          ATTACK
                        </button>
                      <% else %>
                        <span class="text-gray-600 text-xs">-</span>
                      <% end %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("attack", %{"target-id" => target_id}, socket) do
    case Game.declare_war(socket.assigns.country, String.to_integer(target_id)) do
      {:ok, %{attacker: updated_attacker, defender: _updated_defender}} ->
        {:noreply, assign(socket, :country, updated_attacker) |> put_flash(:info, "Attack Successful! Enemy morale damaged.")}
      
      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end

  @impl true
  def handle_event("collect_tax", _params, socket) do
    {:ok, updated_country} = Game.collect_tax(socket.assigns.country, 100)
    # We update immediately. The PubSub message will arrive later and re-update/confirm.
    {:noreply, assign(socket, :country, updated_country)}
  end

  @impl true
  def handle_event("recruit_soldier", _params, socket) do
    case Game.recruit_soldiers(socket.assigns.country, 1) do
      {:ok, updated_country} -> 
        {:noreply, assign(socket, :country, updated_country)}
      
      {:error, reason} -> 
        {:noreply, put_flash(socket, :error, reason)}
    end
  end

  @impl true
  def handle_info({:attacked, victim_id}, socket) do
    if socket.assigns.country && socket.assigns.country.id == victim_id do
      # Trigger visual effect (e.g., shake screen)
      {:noreply, push_event(socket, "trigger-shake", %{}) |> put_flash(:error, "⚠️ YOU ARE UNDER ATTACK! ⚠️")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:world_tick, socket) do
    # Efficiently refresh the whole list and current player state
    countries = Game.list_countries()
    
    new_current_country = 
      if socket.assigns.country do
        Enum.find(countries, fn c -> c.id == socket.assigns.country.id end)
      else
        nil
      end

    {:noreply, assign(socket, countries: countries, country: new_current_country)}
  end

  @impl true
  def handle_info({:country_created, new_country}, socket) do
    # Add the new country to the list
    new_countries = [new_country | socket.assigns.countries]
    {:noreply, assign(socket, :countries, new_countries)}
  end

  @impl true
  def handle_info({:country_updated, updated_country}, socket) do
    # Update the country in the list
    new_countries = 
      Enum.map(socket.assigns.countries, fn c -> 
        if c.id == updated_country.id, do: updated_country, else: c
      end)

    # If the updated country is the player's country, update that too
    new_current_country = 
      if socket.assigns.country && socket.assigns.country.id == updated_country.id do
        updated_country
      else
        socket.assigns.country
      end

    {:noreply, socket |> assign(:countries, new_countries) |> assign(:country, new_current_country)}
  end
end