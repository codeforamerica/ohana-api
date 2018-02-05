class ConfigValidator
  KEYS_THAT_CANNOT_BE_EMPTY = %w[
    ASSET_HOST
    DEFAULT_PER_PAGE
    DOMAIN_NAME
    MAX_PER_PAGE
  ].freeze

  def initialize(env = ENV)
    @env = env
  end

  def validate
    validate_non_empty_required_keys
  end

  private

  attr_reader :env

  def validate_non_empty_required_keys
    empty_keys = required_keys_with_empty_values
    return if empty_keys.empty?
    raise empty_keys_warning(empty_keys)
  end

  def required_keys_with_empty_values
    KEYS_THAT_CANNOT_BE_EMPTY.select { |key| env[key]&.empty? }
  end

  def empty_keys_warning(empty_keys)
    'These configs are required but are empty: ' + empty_keys.join(', ')
  end
end
