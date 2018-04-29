# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :teacher,
  ecto_repos: [Teacher.Repo]

# Configures the endpoint
config :teacher, TeacherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "u7IJXShM3w1O1szOyJBzC3qZnZZoxlkwwEoXhSHIpeuUmyIqG91h9PA960/S3O1E",
  render_errors: [view: TeacherWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Teacher.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# -- Veil Configuration    Don't remove this line
config :veil,
  site_name: "Record Store",
  email_from_name: "Jon Landau",
  email_from_address: "jon@elixircasts.io",
  sign_in_link_expiry: 3_600,
  session_expiry: 86_400 * 30,
  refresh_expiry_interval: 86_400

config :veil,Veil.Scheduler,
  jobs: [
    # Runs every midnight to delete all expired requests and sessions
    {"@daily", {Teacher.Veil.Clean, :expired, []}}
  ]

config :veil, TeacherWeb.Veil.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "YOUR_API_KEY"
