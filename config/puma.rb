# Puma configuration file for the application.

# Threads settings: Minimum and maximum threads per worker
max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS") { 5 })
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS") { max_threads_count })
threads min_threads_count, max_threads_count

# Worker settings: Number of worker processes
# Default to 2 for Heroku or based on `WEB_CONCURRENCY`
if ENV["RAILS_ENV"] == "production"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })
  workers worker_count if worker_count > 1
end

# Preload the application for faster worker boot times
preload_app!

# Port binding: Support IPv6 and fallback to default
port ENV.fetch("PORT") { 3000 }, "::"

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file location
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Turn off keepalive support for better long-tail response times with Heroku Router 2.0
# Remove this line once https://github.com/puma/puma/issues/3487 is resolved
enable_keep_alives(false) if respond_to?(:enable_keep_alives)

# Worker timeout in development environments
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Action to take on worker boot
on_worker_boot do
  # For Rails 4.1 to 5.2, establish ActiveRecord connection on boot
  # No longer necessary for Rails 6+ but kept for compatibility
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Allow Puma to be restarted by `bin/rails restart`
plugin :tmp_restart

# Optional: Default rackup if running standalone
rackup DefaultRackup if defined?(DefaultRackup)
