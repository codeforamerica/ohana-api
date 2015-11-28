workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

# If you turn on preloading (via `preload_app!`), you'll need to uncomment the
# blocks below. The Puma README recommends turning off preloading when the
# number of workers is low.

# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect!
# end

# on_worker_boot do
#   # Worker specific setup for Rails 4.1+
#   # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
#   ActiveRecord::Base.establish_connection
# end
