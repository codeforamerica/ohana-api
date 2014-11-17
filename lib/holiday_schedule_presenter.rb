include ParentAssigner

class HolidaySchedulePresenter < Struct.new(:row)
  def to_holiday_schedule
    holiday_schedule = HolidaySchedule.find_or_initialize_by(id: row[:id].to_i)
    holiday_schedule.attributes = row
    assign_parents_for(holiday_schedule, row)
    holiday_schedule
  end
end
