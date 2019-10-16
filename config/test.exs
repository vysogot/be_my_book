use Mix.Config

config :be_my_book, BeMyBook.Repo,
  database: "be_my_book_test",
  username: "be_my_book_user",
  password: "password",
  hostname: "localhost",
  port: 5496,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :be_my_book, BeMyBookWeb.Endpoint,
  url: [scheme: "http", host: "localhost", port: "4002"],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
