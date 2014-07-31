class FaxValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_fax')}"

    unless value =~ /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
