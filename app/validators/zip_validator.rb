class ZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_zip')}"

    unless value =~ /\A\d{5}(-\d{4})?\z/
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
