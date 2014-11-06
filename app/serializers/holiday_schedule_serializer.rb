class HolidayScheduleSerializer < ActiveModel::Serializer
  attributes :closed, :start_date, :end_date, :opens_at, :closes_at
end
