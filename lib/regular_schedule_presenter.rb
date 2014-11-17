include ParentAssigner

class RegularSchedulePresenter < Struct.new(:row)
  def to_regular_schedule
    regular_schedule = RegularSchedule.find_or_initialize_by(id: row[:id].to_i)
    regular_schedule.attributes = row
    assign_parents_for(regular_schedule, row)
    regular_schedule
  end
end
