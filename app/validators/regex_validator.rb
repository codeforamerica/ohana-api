class RegexValidator < ActiveModel::EachValidator
  def regex_validate_each(regex, err_msg, record, attribute, value)
    return if value =~ regex

    record.errors[attribute] << (options[:message] || err_msg)
  end
end
