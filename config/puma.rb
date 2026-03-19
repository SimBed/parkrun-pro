# bespoke for running locally or on home server
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Use a socket in production
if ENV["RAILS_ENV"] == "production"
  app_dir = "/var/www/parkrun-pro"
  shared_dir = "#{app_dir}/tmp"

  bind "unix://#{shared_dir}/sockets/puma.sock"

  pidfile "#{shared_dir}/pids/puma.pid"
  state_path "#{shared_dir}/pids/puma.state"

  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
  preload_app!
else
port ENV.fetch("PORT") { 3000 }
end

plugin :tmp_restart
