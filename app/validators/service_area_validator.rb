class ServiceAreaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    default_message = "#{value} #{I18n.t('errors.messages.invalid_service_area')}"

    unless SETTINGS[:valid_service_areas].include?(value)
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
