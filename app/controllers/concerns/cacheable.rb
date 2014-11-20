module Cacheable
  def cache_time
    ENV['EXPIRES_IN'].to_i.minutes
  end
end
