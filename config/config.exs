# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello2,
  ecto_repos: [Hello2.Repo]

config :hello2, Hello2.Repo,
  migration_primary_key: [name: :id, type: :binary_id, autogenerate: true]

# Configures the endpoint
config :hello2, Hello2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "B7OP/clytBdeUDq0bZKaEHb/Om16x2Ug9X93xKpg0nQeAe+k74kx1I6KnBWvtkDf",
  render_errors: [view: Hello2Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hello2.PubSub,
  live_view: [signing_salt: "EzuXa8Zq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
