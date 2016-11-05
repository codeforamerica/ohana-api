class StateProvinceValidator < ActiveModel::EachValidator
  COUNTRIES_NEEDING_VALIDATION = %w(US CA).freeze

  def validate_each(record, attribute, value)
    return unless COUNTRIES_NEEDING_VALIDATION.include?(record.country)
    default_message = I18n.t('errors.messages.invalid_state_province')

    return if value.present? && value.size == 2

    record.errors[attribute] << (options[:message] || default_message)
  end
end
