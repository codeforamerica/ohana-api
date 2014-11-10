class UrlValidator < RegexValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_url')}"

    regex = %r{\Ahttps?:\/\/([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i

    regex_validate_each(regex, default_message, record, attribute, value)
  end
end
