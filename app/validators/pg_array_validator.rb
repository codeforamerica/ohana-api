class PgArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    attr = record.read_attribute_before_type_cast(attribute)

    return if attr.include? '{'

    default_message = "#{attr} #{I18n.t('errors.messages.not_an_array')}"
    unless attr.is_a?(Array)
      record.errors[attribute] << (options[:message] || default_message)
      return
    end

    record[attribute] = attr.map(&:squish).reject(&:blank?).uniq
  end
end
