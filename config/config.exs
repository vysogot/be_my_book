# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :be_my_book, ecto_repos: [BeMyBook.Repo]
config :be_my_book, BeMyBook.Repo,
  database: "be_my_book_repo",
  username: "be_my_book_user",
  password: "password",
  hostname: "localhost",
  port: 5496

# Configures the endpoint
config :be_my_book, BeMyBookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VqCehpWlz9UAQ1jj2GyZrsLF5kpKQhJOCR7xbHec1Q1iqwukaLpn4x/RL+JsidB4",
  render_errors: [view: BeMyBookWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BeMyBook.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
