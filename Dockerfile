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

# Copy the mix files first to cache dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy the rest of the application code
COPY . .

# Compile assets
RUN mix assets.deploy

# Compile the project
RUN mix do compile

# The command will be overridden by docker-compose or command line
CMD ["mix", "phx.server"]
