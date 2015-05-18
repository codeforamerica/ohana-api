class RegularScheduleImporter < EntityImporter
  def valid?
    @valid ||= regular_schedules.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(regular_schedules)
  end

  def import
    regular_schedules.each(&:save)
  end

  protected

  def regular_schedules
    @regular_schedules ||= csv_entries.map(&:to_hash).map do |p|
      RegularSchedulePresenter.new(p).to_regular_schedule
    end
  end

  def self.required_headers
    %w(id location_id service_id weekday opens_at closes_at)
  end
end
