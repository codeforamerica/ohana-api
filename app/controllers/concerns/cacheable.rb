module Cacheable
  def cache_time
    ENV['EXPIRES_IN'].to_i.minutes
  end

  def set_cache_control
    expires_in cache_time, public: true
  end
end
