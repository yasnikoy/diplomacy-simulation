defmodule DiplomacyWeb.CountryLive do
  use DiplomacyWeb, :live_view
  alias Diplomacy.Game
  alias Diplomacy.Game.SettingsCache
  alias DiplomacyWeb.Presence

  @presence_topic "presence:countries"

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Game.subscribe()
      Phoenix.PubSub.subscribe(Diplomacy.PubSub, @presence_topic)
    end

    countries = Game.list_countries()
    settings = SettingsCache.get()
    
    current_country = Enum.find(countries, fn c -> to_string(c.id) == id end)

    if current_country do
      {:ok,
       socket
       |> assign(:country, current_country)
       |> assign(:settings, settings)
       |> assign(:show_chat, false)
       |> assign(:selected_role, nil)
       |> assign(:role_counts, %{})
       |> assign(:chat_content, "")
       |> assign(:active_event, nil)
       |> stream(:chat_messages, Game.list_recent_messages())
       |> assign(:countries, countries)}
    else
      {:ok, push_navigate(socket, to: ~p"/")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={"relative flex flex-col lg:flex-row items-start justify-center h-full p-4 lg:p-8 gap-8 bg-gray-900 min-h-screen overflow-hidden " <> if @active_event, do: "pt-14 sm:pt-16 lg:pt-20", else: ""}>
      
      <!-- Global Breaking News Banner -->
      <div :if={@active_event} class="fixed top-0 left-0 w-full z-[100] bg-red-600 border-b border-red-400 shadow-2xl animate-in slide-in-from-top duration-500">
        <div class="flex items-center">
          <div class="bg-black text-white px-4 lg:px-8 py-2 font-black italic tracking-tighter whitespace-nowrap z-10 flex items-center gap-3 text-[10px] sm:text-xs lg:text-base border-r border-red-500/30">
            <span class="animate-pulse text-red-500 text-xs">●</span> BREAKING NEWS
          </div>
          <div class="flex-1 overflow-hidden py-2 bg-red-600 relative px-4 lg:px-10">
            <div class="whitespace-nowrap animate-marquee inline-block font-bold text-white uppercase tracking-wider text-[10px] sm:text-xs lg:text-sm pl-4">
              <%= @active_event.title %>: <%= @active_event.description %> — <%= @active_event.title %>: <%= @active_event.description %>
            </div>
          </div>
          <button phx-click="close_event_banner" class="bg-black/20 hover:bg-black/40 text-white px-4 py-2 transition-colors border-l border-white/10 z-20">
            ✕
          </button>
        </div>
      </div>

      <!-- Role Selection Overlay -->
      <%= if is_nil(@selected_role) do %>
        <div class="fixed inset-0 z-50 bg-gray-950/90 backdrop-blur-sm flex items-center justify-center p-4">
          <div class="bg-gray-800 border border-gray-700 p-8 rounded-2xl max-w-md w-full shadow-2xl animate-in zoom-in duration-300">
            <h2 class="text-3xl font-black text-white mb-2 text-center tracking-tight">SELECT YOUR ROLE</h2>
            <p class="text-gray-400 text-center mb-8">Establish your authority in <%= @country.name %></p>
            
            <div class="grid grid-cols-1 gap-4">
              <%= for role <- String.split(@settings.available_roles, ",") do %>
                <% 
                  role = String.trim(role)
                  count = Map.get(@role_counts, role, 0)
                  is_full = count >= @settings.max_players_per_role
                %>
                <button 
                  phx-click="select_role" 
                  phx-value-role={role} 
                  disabled={is_full}
                  class={"group p-4 rounded-xl transition duration-300 border flex justify-between items-center " <> 
                    if is_full, do: "bg-gray-800 border-gray-700 cursor-not-allowed opacity-50", else: "bg-gray-700 hover:bg-emerald-600 border-gray-600 hover:border-emerald-400"}
                >
                  <div class="flex flex-col items-start">
                    <span class="font-bold text-white text-lg"><%= role %></span>
                    <span class={"text-[10px] uppercase font-bold " <> if is_full, do: "text-red-500", else: "text-gray-400"}><%= count %> / <%= @settings.max_players_per_role %> Active</span>
                  </div>
                  <span :if={!is_full} class="opacity-0 group-hover:opacity-100 transition">➡️</span>
                  <span :if={is_full}>🚫 Full</span>
                </button>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>

      <!-- Player Control Panel -->
      <div class="flex flex-col items-center space-y-6 lg:space-y-8 w-full lg:w-1/3">
        <header class="text-center">
          <h1 class="text-3xl lg:text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-cyan-500 drop-shadow-md">
            Command Center
          </h1>
          <div :if={@selected_role} class="inline-block mt-2 px-3 py-1 bg-gray-800 border border-gray-700 rounded-full text-xs font-bold text-emerald-400 uppercase tracking-widest">
            🎭 <%= @selected_role %>
          </div>
        </header>

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
                  <span>💰</span> <span>Collect Taxes (+<%= @settings.tax_amount %>, -<%= @settings.tax_happiness_penalty %> 🙂)</span>
                </div>
              </button>
              
              <button phx-click="recruit_soldier" class="w-full group relative overflow-hidden bg-red-600 hover:bg-red-500 text-white font-bold py-3 lg:py-4 px-4 lg:px-6 rounded-xl transition duration-300 shadow-lg hover:shadow-red-500/20 active:scale-95 text-sm lg:text-base">
                 <div class="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/10 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></div>
                <div class="flex items-center justify-center gap-2">
                  <span>⚔️</span> <span>Recruit Soldier (Cost: <%= @settings.soldier_cost %>)</span>
                </div>
              </button>
            </div>
          </div>
        <% else %>
          <div class="bg-red-500/10 border border-red-500 text-red-500 p-4 rounded-lg">
            No country found!
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
                        <button phx-click="attack" phx-value-target-id={c.id} class="bg-red-700 hover:bg-red-600 text-white text-xs font-bold py-1 px-2 rounded transition" title={"Cost: #{@settings.attack_cost_soldiers} Army, #{@settings.attack_cost_gold} Gold"}>
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

      <!-- Real-Time Chat Toggle Button -->
      <button :if={@settings.chat_enabled} phx-click="toggle_chat" class="fixed bottom-6 right-6 z-40 bg-emerald-600 hover:bg-emerald-500 text-white p-4 rounded-full shadow-2xl transition active:scale-90">
        <%= if @show_chat, do: "✖️", else: "💬" %>
      </button>

      <!-- Chat Window -->
      <div :if={@show_chat && @settings.chat_enabled} class="fixed bottom-24 right-4 left-4 sm:left-auto sm:right-6 z-40 sm:w-80 lg:w-96 h-[500px] max-h-[70vh] bg-gray-800 border border-gray-700 rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-in slide-in-from-bottom-4 duration-300">
        <header class="bg-gray-750 p-4 border-b border-gray-700 flex justify-between items-center">
          <h3 class="font-bold text-white flex items-center gap-2">
            <span>🌐</span> Global Intelligence
          </h3>
          <span class="text-[10px] bg-emerald-500/20 text-emerald-400 px-2 py-0.5 rounded-full font-bold uppercase">Live</span>
        </header>

        <div id="chat-messages" phx-hook="ChatScroll" phx-update="stream" class="flex-1 overflow-y-auto p-4 space-y-4 custom-scrollbar bg-gray-900/50">
          <%= for {id, msg} <- @streams.chat_messages do %>
            <div id={id} class="flex flex-col gap-1 animate-in fade-in slide-in-from-bottom-1">
              <div class="flex items-center gap-2 text-[10px] font-bold uppercase tracking-tighter">
                <span class="text-blue-400"><%= msg.country_name %></span>
                <span class="text-gray-500">•</span>
                <span class="text-orange-400"><%= msg.role %></span>
              </div>
              <p class="text-sm text-gray-200 bg-gray-700/50 p-2 rounded-lg border border-gray-600/30 inline-block self-start max-w-[90%] break-words">
                <%= msg.content %>
              </p>
            </div>
          <% end %>
        </div>

        <form phx-submit="send_chat" phx-change="sync_chat" class="p-4 bg-gray-750 border-t border-gray-700 flex gap-2">
          <input name="content" value={@chat_content} placeholder="Broadcast message..." autocomplete="off" class="flex-1 bg-gray-900 border-gray-600 text-white rounded-lg text-sm px-3 py-2 focus:ring-emerald-500 focus:border-emerald-500" />
          <button type="submit" class="bg-emerald-600 hover:bg-emerald-500 text-white px-4 py-2 rounded-lg font-bold text-sm transition">
            Send
          </button>
        </form>
      </div>

    </div>
    """
  end

  # Events
  @impl true
  def handle_event("select_role", %{"role" => role}, socket) do
    if connected?(socket) do
      Presence.track(self(), @presence_topic, to_string(socket.assigns.country.id), %{
        role: role,
        country_name: socket.assigns.country.name
      })
    end

    {:noreply, assign(socket, :selected_role, role)}
  end

  @impl true
  def handle_event("toggle_chat", _params, socket) do
    {:noreply, assign(socket, :show_chat, !socket.assigns.show_chat)}
  end

  @impl true
  def handle_event("sync_chat", %{"content" => content}, socket) do
    {:noreply, assign(socket, :chat_content, content)}
  end

  @impl true
  def handle_event("send_chat", %{"content" => content}, socket) do
    if String.trim(content) != "" do
      attrs = %{
        content: content,
        role: socket.assigns.selected_role,
        country_name: socket.assigns.country.name,
        country_id: socket.assigns.country.id
      }
      
      case Game.send_chat_message(attrs) do
        {:ok, _message} -> 
          # Reset chat content locally
          {:noreply, assign(socket, :chat_content, "")}
        _ -> 
          {:noreply, put_flash(socket, :error, "Could not send message")}
      end
    else
      {:noreply, socket}
    end
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
    case Game.collect_tax(socket.assigns.country) do
      {:ok, updated_country} -> {:noreply, assign(socket, :country, updated_country)}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Failed to collect taxes")}
    end
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
  def handle_event("close_event_banner", _params, socket) do
    {:noreply, assign(socket, :active_event, nil)}
  end

  # PubSub Info
  @impl true
  def handle_info({:global_event, event}, socket) do
    # Clear previous timer if any and start a new one to hide the banner after 60s
    Process.send_after(self(), :clear_active_event, 60000)
    
    {:noreply,
     socket
     |> assign(:active_event, event)
     |> push_event("trigger-shake", %{})}
  end

  @impl true
  def handle_info(:clear_active_event, socket) do
    {:noreply, assign(socket, :active_event, nil)}
  end

  @impl true
  def handle_info({:new_chat_message, message}, socket) do
    {:noreply, stream_insert(socket, :chat_messages, message)}
  end

  @impl true
  def handle_info({:settings_updated, settings}, socket) do
    {:noreply, assign(socket, :settings, settings)}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff"}, socket) do
    if socket.assigns[:country] do
      role_counts = 
        Presence.list(@presence_topic)
        |> Map.get(to_string(socket.assigns.country.id), %{metas: []})
        |> Map.get(:metas)
        |> Enum.frequencies_by(& &1.role)

      {:noreply, assign(socket, :role_counts, role_counts)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:attacked, victim_id}, socket) do
    if socket.assigns.country && socket.assigns.country.id == victim_id do
      {:noreply, push_event(socket, "trigger-shake", %{}) |> put_flash(:error, "⚠️ YOU ARE UNDER ATTACK! ⚠️")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:world_tick, socket) do
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
    new_countries = [new_country | socket.assigns.countries]
    {:noreply, assign(socket, :countries, new_countries)}
  end

  @impl true
  def handle_info({:country_updated, updated_country}, socket) do
    # Only update the list, temporary_assigns will handle the rest
    new_countries = 
      Enum.map(socket.assigns.countries, fn c -> 
        if c.id == updated_country.id, do: updated_country, else: c
      end)

    new_current_country = 
      if socket.assigns.country && socket.assigns.country.id == updated_country.id do
        updated_country
      else
        socket.assigns.country
      end

    {:noreply, socket |> assign(:countries, new_countries) |> assign(:country, new_current_country)}
  end
end