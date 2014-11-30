class ZipValidator < RegexValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_zip')}"

    regex = /\A\d{5}(-\d{4})?\z/

    regex_validate_each(regex, default_message, record, attribute, value)
  end
end
