class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
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

  def date_valid?(date)
    return false unless date.include?('/') || date.include?(',')
    return Date.valid_date?(*split_date(date).rotate(2)) if month_day? || date.include?(',')
    return Date.valid_date?(*split_date(date).reverse) if day_month?
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
    return '%Y' if date =~ /\d{4}/
    '%y'
  end
end
