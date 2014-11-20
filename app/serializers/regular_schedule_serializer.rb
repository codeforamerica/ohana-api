class RegularScheduleSerializer < ActiveModel::Serializer
  attributes :weekday, :opens_at, :closes_at
end
