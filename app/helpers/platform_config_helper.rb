module PlatformConfigHelper
  def config_for(*path)
    options = path.find { |el| el.is_a? Hash }
    path.delete_if { |el| el.is_a? Hash }
    PlatformConfigService.new(*path).with_options(options)
  end
end
