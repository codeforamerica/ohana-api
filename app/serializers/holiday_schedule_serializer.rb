class HolidayScheduleSerializer < ActiveModel::Serializer
  attributes :id, :closed, :start_date, :end_date, :opens_at, :closes_at
end
