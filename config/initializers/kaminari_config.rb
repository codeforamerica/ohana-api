# See Kaminari README for more details about config options:
# https://github.com/amatsuda/kaminari#general-configuration-options
# The options below use settings defined in config/settings.yml.
Kaminari.configure do |config|
  config.default_per_page = ENV['DEFAULT_PER_PAGE'].to_i
  config.max_per_page = ENV['MAX_PER_PAGE'].to_i
end
