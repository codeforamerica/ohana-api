class RegularScheduleSerializer < ActiveModel::Serializer
  attributes :weekday, :opens_at, :closes_at

  def weekday
    Admin::FormHelper::WEEKDAYS[object.weekday - 1]
  end
end
