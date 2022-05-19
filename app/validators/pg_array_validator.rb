class PgArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    attr = record.read_attribute_before_type_cast(attribute)
    return if does_not_need_validation?(attr)

    default_message = "#{attr} #{I18n.t('errors.messages.not_an_array')}"
    unless attr.is_a?(Array)
      record.errors.add(attribute, (options[:message] || default_message))
      return
    end

    record[attribute] = attr.map(&:squish).reject(&:blank?).uniq
  end

  def does_not_need_validation?(attr)
    # The class comparison is necessary because Rails 5 is doing something
    # strange when updating records that is causing the attribute before type
    # casting to be an object of the below class.
    (attr.include? '{') ||
      attr.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array::Data)
  end
end
