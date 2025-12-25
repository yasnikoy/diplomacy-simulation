# Diplomacy Simulation

A real-time geopolitical strategy game built with the PETAL stack (Phoenix, Elixir, Tailwind, Alpine, LiveView). Designed for high concurrency and fault tolerance, featuring live updates, economic simulation, and military mechanics.

## Tech Stack

*   **Language:** Elixir (OTP)
*   **Framework:** Phoenix LiveView 1.7+
*   **Database:** PostgreSQL (Ecto)
*   **Styling:** Tailwind CSS v4
*   **Real-time:** Phoenix PubSub & Presence

## Features

### Core Mechanics
*   **Real-time Economy:** Passive income generation and tax collection system affecting national happiness.
*   **Military System:** Recruit soldiers, manage army size, and declare war with immediate consequences.
*   **Global Events Engine:** Dynamic random events (e.g., Economic Boom, Market Crash) that affect all players simultaneously.
*   **News Ticker:** Live "Breaking News" banner broadcasting global events to all connected clients.

### Interface
*   **Live Dashboard:** Real-time updates for budget, army, and morale without page reloads.
*   **Admin Panel:** Comprehensive control over game settings, country management, and event probability.
*   **Reactive UI:** Mobile-responsive design with visual feedback (shake effects, rolling numbers).

## Setup (Local Development)

### Prerequisites
*   Elixir 1.15+
*   PostgreSQL 14+

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/yasnikoy/diplomacy-simulation.git
    cd diplomacy-simulation
    ```

2.  Install dependencies:
    ```bash
    mix deps.get
    ```

3.  Setup database:
    ```bash
    mix ecto.setup
    ```

4.  Start the server:
    ```bash
    mix phx.server
    ```

Visit `localhost:4000` in your browser.

## Setup (Docker)

Ideal for production or quick testing without local dependencies.

1.  Build and run containers:
    ```bash
    docker-compose up -d --build
    ```

2.  Access the application at `localhost:4000`.

## Production Deployment

Configuration files are located in the `deploy/` directory.

1.  Navigate to deploy folder:
    ```bash
    cd deploy
    ```

2.  Create `.env` file from example:
    ```bash
    cp .env.example .env
    # Edit .env with your production secrets
    ```

3.  Deploy with Docker Compose:
    ```bash
    docker-compose -f docker-compose.prod.yml up -d --build
    ```

## Project Structure

*   `lib/diplomacy/game` - Core business logic (Contexts, Schemas).
*   `lib/diplomacy/game/ticker.ex` - GenServer for time-based simulation ticks.
*   `lib/diplomacy_web/live` - LiveView modules for frontend interaction.
*   `priv/repo/migrations` - Database schema changes.

## Testing

Run the test suite to verify mechanics:

```bash
mix test
```