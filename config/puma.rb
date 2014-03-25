workers Integer(ENV['PUMA_WORKERS'] || 3)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  if defined?(Redis)
    REDIS = Redis.connect(url: ENV["REDISTOGO_URL"])
    Rails.logger.info('Connected to Redis')
  end
end