class RegularSchedule < ApplicationRecord
  include ParentPresenceValidatable

  default_scope { order('weekday ASC') }

  belongs_to :location, optional: true, touch: true, inverse_of: :regular_schedules
  belongs_to :service, optional: true, touch: true, inverse_of: :regular_schedules

  validates :weekday, :opens_at, :closes_at,
            presence: { message: I18n.t('errors.messages.blank_for_rs') }

  validates :weekday, weekday: { allow_blank: true }
end
