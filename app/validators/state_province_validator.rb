class StateProvinceValidator < ActiveModel::EachValidator
  COUNTRIES_NEEDING_VALIDATION = %w(US CA).freeze

  def validate_each(record, attribute, value)
    return if value.blank?
    return unless COUNTRIES_NEEDING_VALIDATION.include?(record.country)
    default_message = I18n.t('errors.messages.invalid_state_province')

    unless value.size == 2
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
