threads 0, 16
# workers 2
# preload_app!

# on_restart do
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.connection.disconnect!
#     Rails.logger.info('Disconnected from ActiveRecord')
#   end

#   if defined?(Redis)
#     REDIS.quit
#     Rails.logger.info('Disconnected from Redis')
#   end
# end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # if defined?(Redis)
  #   REDIS = Redis.connect(url: ENV['REDISTOGO_URL'])
  #   Rails.logger.info('Connected to Redis')
  # end
end
