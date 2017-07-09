class RegularScheduleImporter < EntityImporter
  def valid?
    @valid ||= regular_schedules.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(regular_schedules)
  end

  def import
    ActiveRecord::Base.no_touching do
      regular_schedules.each(&:save)
    end
  end

  def self.required_headers
    %w[id location_id service_id weekday opens_at closes_at]
  end

  protected

  def regular_schedules
    @regular_schedules ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << RegularSchedulePresenter.new(row).to_regular_schedule }
    end
  end
end
