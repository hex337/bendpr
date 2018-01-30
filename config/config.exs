# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bendpr,
  ecto_repos: [Bendpr.Repo]

# Configures the endpoint
config :bendpr, BendprWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zSU8QXi3qgoexc6qcT/YZEEIhqqnHd4sHeWdqW/p2ZDRCKWmkM/HqTszo4mcPWP7",
  render_errors: [view: BendprWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bendpr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure the Slack Bot
config :bendpr, Bendpr.Slack,
  token: System.get_env("SLACK_TOKEN"),
  github: System.get_env("GITHUB_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
