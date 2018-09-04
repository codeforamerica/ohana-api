class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    value = record.read_attribute_before_type_cast(attribute)
    return if value.blank? || value.is_a?(Date)

    default_message = "#{value} #{I18n.t('errors.messages.invalid_date')}"

    unless date_valid?(value)
      record.errors[attribute] << (options[:message] || default_message)
      return
    end

    convert_value_to_date(record, attribute, value)
  end

  private

  # This is necessary to work around a Rails bug:
  # https://github.com/rails/rails/issues/28521
  def date_from_hash(date)
    time = ::Time.utc(date[1], date[2], date[3])
    ::Date.new(time.year, time.mon, time.mday)
  end

  def date_valid?(date)
    return valid_date_from_hash?(date) if date.is_a?(Hash)
    return false unless valid_date_format?(date)
    return Date.valid_date?(*split_date(date).rotate(2)) if month_day? || date.include?(',')
    return Date.valid_date?(*split_date(date).reverse) if day_month?
  end

  def valid_date_format?(date)
    date.include?('/') || date.include?(',')
  end

  def valid_date_from_hash?(date)
    date_from_hash(date).is_a?(Date)
  end

  def month_day?
    SETTINGS[:date_format] == '%m/%d/'
  end

  def day_month?
    SETTINGS[:date_format] == '%d/%m/'
  end

  def split_date(date)
    if date.include?('/')
      date.split('/').map(&:to_i)
    else
      date.tr(',', '').split(' ').map.with_index do |e, i|
        i.zero? ? Date::MONTHNAMES.index(e) || 0 : e.to_i
      end
    end
  end

  def convert_value_to_date(record, attribute, value)
    return record[attribute] = date_from_hash(value) if value.is_a?(Hash)
    record[attribute] = parse_date(value)
  end

  def parse_date(date)
    return Date.parse(date) if date.include?(',')

    Date.strptime(date, date_format_for(date))
  end

  def date_format_for(date)
    SETTINGS[:date_format] + year_format_for(date)
  end

  def year_format_for(date)
    return '%Y' if date.match?(/\d{4}/)
    '%y'
  end
end
