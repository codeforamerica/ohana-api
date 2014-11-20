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
    return true unless date.include?('/')
    return Date.valid_date?(year(date), month(date), day(date)) if month_day?
    return Date.valid_date?(year(date), day(date), month(date)) if day_month?
  end

  def month_day?
    SETTINGS[:date_format] == '%m/%d/'
  end

  def day_month?
    SETTINGS[:date_format] == '%d/%m/'
  end

  def split_date(date)
    date.split('/')
  end

  def year(date)
    split_date(date).last.to_i
  end

  def month(date)
    split_date(date).first.to_i
  end

  def day(date)
    split_date(date).second.to_i
  end

  def convert_value_to_date(record, attribute, value)
    record[attribute] = parse_date(value)
  end

  def parse_date(date)
    Date.strptime(date, date_format_for(date)) rescue Date.parse(date)
  end

  def date_format_for(date)
    SETTINGS[:date_format] + year_format_for(date)
  end

  def year_format_for(date)
    return '%Y' if date =~ /\d{4}/
    '%y'
  end
end
