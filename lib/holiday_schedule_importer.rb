class HolidayScheduleImporter < EntityImporter
  def valid?
    @valid ||= holiday_schedules.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(holiday_schedules)
  end

  def import
    holiday_schedules.each(&:save!) if valid?
  end

  protected

  def holiday_schedules
    @holiday_schedules ||= csv_entries.map(&:to_hash).map do |p|
      HolidaySchedulePresenter.new(p).to_holiday_schedule
    end
  end

  def self.required_headers
    %w(id location_id service_id closed start_date end_date opens_at
       closes_at)
  end
end
