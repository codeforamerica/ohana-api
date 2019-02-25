class RegularScheduleSerializer < ActiveModel::Serializer
  attributes :id, :weekday, :opens_at, :closes_at
end
