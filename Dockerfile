FROM elixir:1.17

# Install build dependencies
# inotify-tools is required for Phoenix live reloading on Linux
RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools && \
    rm -rf /var/lib/apt/lists/*

# Install Hex package manager and Rebar build tool
RUN mix local.hex --force && \
    mix local.rebar --force

# Set working directory
WORKDIR /app

# The command will be overridden by docker-compose or command line
CMD ["mix", "phx.server"]
