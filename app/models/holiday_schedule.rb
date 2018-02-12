class HolidaySchedule < ApplicationRecord
  include ParentPresenceValidatable

  belongs_to :location, touch: true, inverse_of: :holiday_schedules
  belongs_to :service, touch: true, inverse_of: :holiday_schedules

  validates :start_date, :end_date,
            date: true,
            presence: { message: I18n.t('errors.messages.blank_for_hs') }

  validates :opens_at, :closes_at,
            presence: { message: I18n.t('errors.messages.blank_for_hs_open') },
            unless: :closed?
end
