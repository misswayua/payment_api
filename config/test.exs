use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :promo_code, PromoCodeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :promo_code, PromoCode.Repo,
  username: "postgres",
  password: "postgres",
  database: "promo_code_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
