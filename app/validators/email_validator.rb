class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "#{value} is not a valid email") unless value =~ /.+@.+\..+/i
  end
end
