class RegularScheduleImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && regular_schedules.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(regular_schedules)
  end

  def import
    regular_schedules.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id service_id weekday opens_at closes_at).map(&:to_sym)
  end

  protected

  def regular_schedules
    @regular_schedules ||= csv_entries.map(&:to_hash).map do |p|
      RegularSchedulePresenter.new(p).to_regular_schedule
    end
  end
end
