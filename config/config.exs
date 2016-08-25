# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :peepy,
  ecto_repos: [Peepy.Repo]

# Configures the endpoint
config :peepy, Peepy.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nMBnxKKZFpCmkjOn53JmqHbYGylPOmPS7QgTzLzSXlpKG0N53Bh8g+ZB7guQNBRg",
  render_errors: [view: Peepy.ErrorView, accepts: ~w(json)],
  pubsub: [name: Peepy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Peepy",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET") || "64rjPLZeWyfBQrBoLV6qEgMGaeCjI8HuuEG+WNbZI1OP/YVgXQSR2kbG+ClrCEDu",
  serializer: Peepy.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
