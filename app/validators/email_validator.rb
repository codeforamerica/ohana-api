class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_email')}"

    unless value =~ /.+@.+\..+/i
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
