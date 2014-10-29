class WeekdayValidator < ActiveModel::EachValidator
  WEEKDAY_ABBREVIATIONS = %w(Sun Mon Tue Wed Thu Fri Sat).freeze
  WEEKDAY_STRING_NUMS = %w(1 2 3 4 5 6 7).freeze

  def validate_each(record, attribute, value)
    value = record.read_attribute_before_type_cast(attribute)

    default_message = "#{value} #{I18n.t('errors.messages.invalid_weekday')}"

    unless valid_weekday_num?(value) || valid_weekday_name?(value)
      record.errors[attribute] << (options[:message] || default_message)
      return
    end

    convert_value_to_integer(record, attribute, value)
  end

  private

  def valid_weekday_num?(value)
    (value.is_a?(Integer) && value.to_i.between?(1, 7)) || valid_string_num?(value)
  end

  def valid_string_num?(value)
    WEEKDAY_STRING_NUMS.include?(value)
  end

  def valid_weekday_name?(value)
    value.is_a?(String) && starts_with_weekday_abbreviation?(value)
  end

  def starts_with_weekday_abbreviation?(value)
    WEEKDAY_ABBREVIATIONS.select { |abbr| value.start_with?(abbr) }.present?
  end

  def convert_value_to_integer(record, attribute, value)
    record[attribute] = value.to_i if valid_weekday_num?(value)
    record[attribute] = wday_name_to_int(value) if valid_weekday_name?(value)
  end

  def wday_name_to_int(value)
    DateTime.parse(value).strftime('%u').to_i
  end
end
