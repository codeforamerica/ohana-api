class ServiceAreaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || SETTINGS[:valid_service_areas].blank?
    default_message = "#{value} #{I18n.t('errors.messages.invalid_service_area')}"

    return if SETTINGS[:valid_service_areas].include?(value)

    record.errors[attribute] << (options[:message] || default_message)
  end
end
