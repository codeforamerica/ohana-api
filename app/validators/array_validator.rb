# This custom validator allows you to validate each element in an Array field.
# Source: https://gist.github.com/ssimeonov/6519423
# See app/models/location.rb for usage. Here's an example:
# validates :admin_emails, array: {
#                      format: { with: /some regex/,
#                                 message: "Please enter a valid email" } }
class ArrayValidator < ActiveModel::EachValidator
  def initialize(options)
    super
    @validators = options.except(:class).map do |(key, args)|
      create_validator(key, args)
    end
  end

  def validate_each(record, attribute, values)
    helper = Helper.new(@validators, record, attribute)
    Array.wrap(values).each do |value|
      helper.validate(value)
    end
  end

  private

  class Helper
    def initialize(validators, record, attribute)
      @validators = validators
      @record = record
      @attribute = attribute
    end

    def validate(value)
      @validators.each do |validator|
        next if value.nil? && validator.options[:allow_nil]
        next if value.blank? && validator.options[:allow_blank]
        run_validator(validator, value)
      end
    end

    def run_validator(validator, value)
      validator.validate_each(@record, @attribute, value)
    rescue NotImplementedError
      validator.validate(@record)
    end
  end

  def create_validator(key, args)
    opts = { attributes: attributes }
    opts.merge!(args) if args.is_a?(Hash)
    validator_class(key).new(opts).tap(&:check_validity!)
  end

  def validator_class(key)
    validator_class_name = "#{key.to_s.camelize}Validator"
    validator_class_name.constantize
  rescue NameError
    "ActiveModel::Validations::#{validator_class_name}".constantize
  end
end
