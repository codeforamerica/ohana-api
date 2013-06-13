class HashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    if values.present?
      values.each do |array|
        array.each do |hash|
          value = hash["number"]
          options.each do |key, args|
            validator_options = { attributes: attribute }
            validator_options.merge!(args) if args.is_a?(Hash)

            next if value.blank? && validator_options[:allow_blank]

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
end