class RegularSchedule < ActiveRecord::Base
  include ParentPresenceValidatable

  default_scope { order('weekday ASC') }

  attr_accessible :weekday, :opens_at, :closes_at

  belongs_to :location, touch: true
  belongs_to :service, touch: true, inverse_of: :regular_schedules

  validates :weekday, :opens_at, :closes_at,
            presence: { message: I18n.t('errors.messages.blank_for_rs') }

  validates :weekday, weekday: { allow_blank: true }
end
