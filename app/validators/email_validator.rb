class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    default_message = "#{value} #{I18n.t('errors.messages.invalid_email')}"

    unless value =~ /\A([^@\s]+)@((?:(?!-)[-a-z0-9]+(?<!-)\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
