class PgArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    attr = record.read_attribute_before_type_cast(attribute)

    return if attr.include? '{'

    fail ActiveRecord::SerializationTypeMismatch unless attr.is_a?(Array)

    record[attribute] = attr.map(&:squish).reject(&:blank?).uniq
  end
end
