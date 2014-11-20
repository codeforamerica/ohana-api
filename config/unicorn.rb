worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    Rails.logger.info('Unicorn master intercepting TERM and sending myself QUIT instead')
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  if defined?(Redis)
    REDIS.quit
    Rails.logger.info('Disconnected from Redis')
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    Rails.logger.info('Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT')
  end

  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            =   ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
    Rails.logger.info('Connected to ActiveRecord')
  end

  if defined?(Redis)
    REDIS = Redis.connect(url: ENV['REDISTOGO_URL'])
    Rails.logger.info('Connected to Redis')
  end
end
