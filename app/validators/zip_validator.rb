class ZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "#{value} is not a valid ZIP code") unless value =~ /\A\d{5}(-\d{4})?\z/
  end
end
