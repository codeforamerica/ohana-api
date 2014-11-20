class HolidayScheduleImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && holiday_schedules.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(holiday_schedules)
  end

  def import
    holiday_schedules.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id service_id closed start_date end_date opens_at
       closes_at).map(&:to_sym)
  end

  protected

  def holiday_schedules
    @holiday_schedules ||= csv_entries.map(&:to_hash).map do |p|
      HolidaySchedulePresenter.new(p).to_holiday_schedule
    end
  end
end
