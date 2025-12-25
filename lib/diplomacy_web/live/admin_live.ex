defmodule DiplomacyWeb.AdminLive do
  use DiplomacyWeb, :live_view
  alias Diplomacy.Game
  alias Diplomacy.Game.SettingsCache
  alias Diplomacy.Repo
  alias Diplomacy.Game.Country

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Game.subscribe()

    settings = SettingsCache.get()
    # Standard Phoenix 1.7 form initialization from a changeset
    form = settings |> Diplomacy.Game.Settings.changeset(%{}) |> to_form()

    {:ok, 
     socket 
     |> assign(:settings, settings)
     |> assign(:form, form)
     |> assign(:active_tab, "economics")
     |> assign(:is_dirty, false)
     |> stream(:countries, Game.list_countries())
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen bg-gray-950 text-white overflow-hidden font-sans">
      <!-- Sidebar -->
      <aside class="w-72 bg-gray-900 border-r border-gray-800 flex flex-col">
        <div class="p-6">
          <h1 class="text-xl font-black text-red-500 tracking-tighter uppercase">Admin Panel</h1>
          <p class="text-[10px] text-gray-500 mt-1 italic font-mono uppercase tracking-widest">Simulation Control v2.1</p>
        </div>

        <nav class="flex-1 px-4 space-y-1">
          <button phx-click="set_tab" phx-value-tab="economics" class={"w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition " <> if @active_tab == "economics", do: "bg-emerald-600/10 text-emerald-400 border border-emerald-600/20", else: "text-gray-400 hover:bg-gray-800 hover:text-white"}>
            <div class="flex items-center gap-3"><span>💰</span> Economics</div>
            <div :if={@active_tab == "economics"} class="w-1.5 h-1.5 rounded-full bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.6)]"></div>
          </button>
          <button phx-click="set_tab" phx-value-tab="military" class={"w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition " <> if @active_tab == "military", do: "bg-orange-600/10 text-orange-400 border border-orange-600/20", else: "text-gray-400 hover:bg-gray-800 hover:text-white"}>
            <div class="flex items-center gap-3"><span>⚔️</span> Military</div>
            <div :if={@active_tab == "military"} class="w-1.5 h-1.5 rounded-full bg-orange-500 shadow-[0_0_8px_rgba(249,115,22,0.6)]"></div>
          </button>
          <button phx-click="set_tab" phx-value-tab="nations" class={"w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition " <> if @active_tab == "nations", do: "bg-blue-600/10 text-blue-400 border border-blue-600/20", else: "text-gray-400 hover:bg-gray-800 hover:text-white"}>
            <div class="flex items-center gap-3"><span>🌍</span> Nations</div>
            <div :if={@active_tab == "nations"} class="w-1.5 h-1.5 rounded-full bg-blue-500 shadow-[0_0_8px_rgba(59,130,246,0.6)]"></div>
          </button>
        </nav>

        <!-- Dynamic Save/Cancel Buttons -->
        <div :if={@is_dirty} class="p-4 mx-4 mb-4 bg-emerald-600/5 border border-emerald-500/20 rounded-xl animate-in fade-in zoom-in duration-300">
          <p class="text-[10px] text-emerald-500 font-bold uppercase mb-2 text-center">Unsaved Changes</p>
          <div class="space-y-2">
            <button form="global-settings-form" type="submit" class="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-2 rounded-lg transition shadow-lg shadow-emerald-900/40 text-sm">
              Apply Changes
            </button>
            <button phx-click="discard_changes" class="w-full bg-gray-800 hover:bg-gray-700 text-gray-400 font-bold py-2 rounded-lg transition text-sm">
              Discard
            </button>
          </div>
        </div>

        <!-- Danger Zone Sidebar Section -->
        <div class="p-4 mt-auto border-t border-gray-800 bg-red-950/5">
          <h3 class="text-[10px] font-bold text-red-500/50 uppercase tracking-widest mb-3 px-2">Danger Zone</h3>
          <div class="space-y-1">
            <button phx-click="reset_game" data-confirm="☢️ GLOBAL RESET: This will delete ALL nations. Proceed?" class="w-full flex items-center gap-3 px-4 py-2 text-xs rounded-lg text-red-400/70 hover:bg-red-600 hover:text-white transition border border-red-900/20">
              <span>☣️</span> Reset World
            </button>
            <.link navigate={~p"/"} class="w-full flex items-center gap-3 px-4 py-2 text-xs rounded-lg text-gray-500 hover:bg-gray-800 hover:text-white transition">
              <span>🚪</span> Exit Admin
            </.link>
          </div>
        </div>
      </aside>

      <!-- Main Content Area -->
      <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
        <div class="max-w-3xl">
          <.form for={@form} id="global-settings-form" phx-change="validate_settings" phx-submit="save_settings">
            
            <div :if={@active_tab == "economics"} class="space-y-6 animate-in fade-in slide-in-from-right-2 duration-300">
              <header>
                <h2 class="text-2xl font-bold text-emerald-400">Economic Policy</h2>
                <p class="text-sm text-gray-500 mt-1">Configure revenue and costs.</p>
              </header>

              <div class="bg-gray-900 rounded-2xl border border-gray-800 divide-y divide-gray-800 overflow-hidden">
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Starting Budget</span>
                    <span class="text-[10px] text-gray-500 uppercase">Initial gold for new nations</span>
                  </div>
                  <.input field={@form[:starting_budget]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-emerald-500 focus:ring-0 text-right font-mono text-emerald-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Starting Army</span>
                    <span class="text-[10px] text-gray-500 uppercase">Initial soldiers for new nations</span>
                  </div>
                  <.input field={@form[:starting_army]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono text-orange-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Tax Amount</span>
                    <span class="text-[10px] text-gray-500 uppercase">Gold gained per tax collection</span>
                  </div>
                  <.input field={@form[:tax_amount]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-emerald-500 focus:ring-0 text-right font-mono text-emerald-400 rounded-md transition-all" />
                </div>
                
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Tax Morale Penalty</span>
                    <span class="text-[10px] text-gray-500 uppercase">Happiness lost per tax collection</span>
                  </div>
                  <.input field={@form[:tax_happiness_penalty]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-red-500 focus:ring-0 text-right font-mono text-red-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Passive Gold</span>
                    <span class="text-[10px] text-gray-500 uppercase">Gold gained per simulation tick</span>
                  </div>
                  <.input field={@form[:passive_income_amount]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-emerald-500 focus:ring-0 text-right font-mono text-emerald-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Passive Morale</span>
                    <span class="text-[10px] text-gray-500 uppercase">Happiness gained per simulation tick</span>
                  </div>
                  <.input field={@form[:passive_income_happiness_inc]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-blue-500 focus:ring-0 text-right font-mono text-blue-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Soldier Unit Cost</span>
                    <span class="text-[10px] text-gray-500 uppercase">Gold cost to recruit one soldier</span>
                  </div>
                  <.input field={@form[:soldier_cost]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono text-orange-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Chat Enabled</span>
                    <span class="text-[10px] text-gray-500 uppercase">Global communication control</span>
                  </div>
                  <.input field={@form[:chat_enabled]} type="checkbox" class="w-6 h-6 rounded border-gray-800 bg-gray-950 text-emerald-500 focus:ring-0" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Available Roles</span>
                    <span class="text-[10px] text-gray-500 uppercase">Comma separated role names</span>
                  </div>
                  <.input field={@form[:available_roles]} type="text" class="w-48 bg-gray-950 border-gray-800 focus:border-blue-500 focus:ring-0 text-right text-xs font-mono text-blue-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Max Players Per Role</span>
                    <span class="text-[10px] text-gray-500 uppercase">Limit concurrent sessions per role</span>
                  </div>
                  <.input field={@form[:max_players_per_role]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-emerald-500 focus:ring-0 text-right font-mono text-emerald-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Admin Inject Amount</span>
                    <span class="text-[10px] text-gray-500 uppercase">Gold amount for admin manual injection</span>
                  </div>
                  <.input field={@form[:admin_inject_amount]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-emerald-500 focus:ring-0 text-right font-mono text-emerald-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition border-t-2 border-purple-500/20 bg-purple-500/5">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-purple-300">Global Events Enabled</span>
                    <span class="text-[10px] text-purple-500/70 uppercase font-bold">Chaos & Opportunity engine</span>
                  </div>
                  <.input field={@form[:event_enabled]} type="checkbox" class="w-6 h-6 rounded border-purple-800 bg-gray-950 text-purple-500 focus:ring-0" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition bg-purple-500/5">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-purple-300">Event Probability (%)</span>
                    <span class="text-[10px] text-purple-500/70 uppercase font-bold">Chance per simulation tick</span>
                  </div>
                  <.input field={@form[:event_probability]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-purple-500 focus:ring-0 text-right font-mono text-purple-400 rounded-md transition-all" />
                </div>

                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <div class="flex flex-col">
                    <span class="text-sm font-medium text-gray-300">Tick Interval (ms)</span>
                    <span class="text-[10px] text-gray-500 uppercase">Simulation speed (Lower is faster)</span>
                  </div>
                  <.input field={@form[:passive_income_interval_ms]} type="number" step="100" class="w-24 bg-gray-950 border-gray-800 focus:border-purple-500 focus:ring-0 text-right font-mono text-purple-400 rounded-md transition-all" />
                </div>
              </div>
            </div>

            <div :if={@active_tab == "military"} class="space-y-6 animate-in fade-in slide-in-from-right-2 duration-300">
              <header>
                <h2 class="text-2xl font-bold text-orange-400">Military Doctrine</h2>
                <p class="text-sm text-gray-500 mt-1">Rules of engagement and combat lethality.</p>
              </header>

              <div class="bg-gray-900 rounded-2xl border border-gray-800 divide-y divide-gray-800 overflow-hidden">
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Attack Cost (Gold)</span>
                  <.input field={@form[:attack_cost_gold]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Attack Cost (Army)</span>
                  <.input field={@form[:attack_cost_soldiers]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Min Damage</span>
                  <.input field={@form[:attack_damage_min]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Max Damage</span>
                  <.input field={@form[:attack_damage_max]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Attacker Morale Penalty</span>
                  <.input field={@form[:attack_happiness_penalty_attacker]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-red-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Defender Morale Penalty</span>
                  <.input field={@form[:attack_happiness_penalty_defender]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-red-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
                <div class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition">
                  <span class="text-sm font-medium text-gray-300">Defender Budget Multiplier</span>
                  <.input field={@form[:attack_defender_budget_multiplier]} type="number" class="w-24 bg-gray-950 border-gray-800 focus:border-orange-500 focus:ring-0 text-right font-mono rounded-md transition-all" />
                </div>
              </div>
            </div>
          </.form>

          <div :if={@active_tab == "nations"} class="space-y-6 animate-in fade-in slide-in-from-right-2 duration-300">
            <header>
              <h2 class="text-2xl font-bold text-blue-400">Nation Registry</h2>
              <p class="text-sm text-gray-500 mt-1">Direct intervention in nation states.</p>
            </header>

            <div id="countries-list" phx-update="stream" class="bg-gray-900 rounded-2xl border border-gray-800 divide-y divide-gray-800 overflow-hidden">
              <%= for {id, c} <- @streams.countries do %>
                <div id={id} class="flex items-center justify-between p-4 hover:bg-gray-800/50 transition group">
                  <div class="flex flex-col">
                    <span class="text-sm font-bold text-white"><%= c.name %></span>
                    <span class="text-[10px] font-mono text-gray-500">
                      💰 <%= c.budget %> | ⚔️ <%= c.army_count %> | 🙂 <%= c.happiness %>%
                    </span>
                  </div>
                  <div class="flex gap-2">
                    <button phx-click="inject_resources" phx-value-id={c.id} class="text-[10px] font-bold px-3 py-1 bg-blue-600/10 text-blue-400 border border-blue-600/20 rounded-lg hover:bg-blue-600 hover:text-white transition">
                      +1K GOLD
                    </button>
                    <button phx-click="delete_country" phx-value-id={c.id} data-confirm={"Delete #{c.name}?"} class="text-[10px] font-bold px-3 py-1 bg-red-600/10 text-red-500 border border-red-600/20 rounded-lg hover:bg-red-600 hover:text-white transition">
                      DELETE
                    </button>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </main>
    </div>
    """
  end

  @impl true
  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  @impl true
  def handle_event("validate_settings", %{"settings" => params}, socket) do
    form = 
      socket.assigns.settings
      |> Diplomacy.Game.Settings.changeset(params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, 
     socket 
     |> assign(:form, form)
     |> assign(:is_dirty, true)}
  end

  @impl true
  def handle_event("save_settings", %{"settings" => params}, socket) do
    case SettingsCache.update(params) do
      {:ok, settings} ->
        {:noreply, 
         socket 
         |> assign(:settings, settings)
         |> assign(:form, settings |> Diplomacy.Game.Settings.changeset(%{}) |> to_form())
         |> assign(:is_dirty, false)
         |> put_flash(:info, "Settings globally applied!")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("discard_changes", _params, socket) do
    settings = SettingsCache.get()
    form = settings |> Diplomacy.Game.Settings.changeset(%{}) |> to_form()
    
    {:noreply, 
     socket 
     |> assign(:form, form)
     |> assign(:is_dirty, false)
     |> put_flash(:info, "Changes discarded.")}
  end

  @impl true
  def handle_event("inject_resources", %{"id" => id}, socket) do
    country = Game.get_country!(id)
    Game.update_country(country, %{budget: country.budget + socket.assigns.settings.admin_inject_amount})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_country", %{"id" => id}, socket) do
    country = Game.get_country!(id)
    Game.delete_country(country)
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset_game", _params, socket) do
    Repo.delete_all(Country)
    Repo.delete_all(Diplomacy.Game.ChatMessage)
    # Reset Ticker implicitly by resetting world
    Phoenix.PubSub.broadcast(Diplomacy.PubSub, "game:global", :world_tick)
    {:noreply, 
      socket 
      |> stream(:countries, [], reset: true)
      |> put_flash(:info, "WORLD & CHAT RESET SUCCESSFUL")}
  end

  @impl true
  def handle_info(:world_tick, socket) do
    {:noreply, stream(socket, :countries, Game.list_countries(), reset: true)}
  end

  @impl true
  def handle_info({:country_created, country}, socket) do
    {:noreply, stream_insert(socket, :countries, country, at: 0)}
  end

  @impl true
  def handle_info({:country_updated, country}, socket) do
    {:noreply, stream_insert(socket, :countries, country)}
  end

  @impl true
  def handle_info({:settings_updated, settings}, socket) do
    # Eğer kullanıcı o an bir şeyler yazmıyorsa (dirty değilse) formu güncelle
    if socket.assigns.is_dirty do
      {:noreply, assign(socket, :settings, settings)}
    else
      {:noreply, 
       socket 
       |> assign(:settings, settings)
       |> assign(:form, settings |> Diplomacy.Game.Settings.changeset(%{}) |> to_form())}
    end
  end
end
