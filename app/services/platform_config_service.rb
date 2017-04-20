class PlatformConfigService
  def initialize(*path)
    @path ||= path
    @json ||= YAML.load_file("config/platform/#{@path.first}.yml").with_indifferent_access
  end

  def with_options(options = {})
    result.to_hash.reduce({}) { |h, (k, v)| h.merge(k => v % options) }
  end

  private

  def result
    @result ||= @path.inject(@json) { |v, k| v && v[k] }
  end
end
