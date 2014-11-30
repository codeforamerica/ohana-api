class EmailValidator < RegexValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_email')}"

    regex =  /\A([^@\s]+)@((?:(?!-)[-a-z0-9]+(?<!-)\.)+[a-z]{2,})\z/i

    regex_validate_each(regex, default_message, record, attribute, value)
  end
end
