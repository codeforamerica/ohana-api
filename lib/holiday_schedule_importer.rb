class HolidayScheduleImporter < EntityImporter
  def valid?
    @valid ||= holiday_schedules.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(holiday_schedules)
  end

  def import
    ActiveRecord::Base.no_touching do
      holiday_schedules.each(&:save)
    end
  end

  def self.required_headers
    %w[id location_id service_id closed start_date end_date opens_at
       closes_at]
  end

  protected

  def holiday_schedules
    @holiday_schedules ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << HolidaySchedulePresenter.new(row).to_holiday_schedule }
    end
  end
end
