# This custom validator allows you to validate Mongoid Array fields
# http://zogovic.com/post/32932492190/how-to-validate-array-fields-in-mongoid
# See app/models/organization.rb for usage. Here's an example:
# validates :emails, array: {
#                      format: { with: /some regex/,
#                                 message: "Please enter a valid email" } }

class ArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    if values.present?
      [values].flatten.each do |value|
        options.each do |key, args|
          validator_options = { attributes: attribute }
          validator_options.merge!(args) if args.is_a?(Hash)

          validator_class_name = "#{key.to_s.camelize}Validator"
          validator_class = begin
            validator_class_name.constantize
          rescue NameError
            "ActiveModel::Validations::#{validator_class_name}".constantize
          end

          validator = validator_class.new(validator_options)
          validator.validate_each(record, attribute, value)
        end
      end
    end
  end
end