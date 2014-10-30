class HolidaySchedule < ActiveRecord::Base
  attr_accessible :closed, :start_date, :end_date, :opens_at, :closes_at

  belongs_to :location, touch: true
  belongs_to :service, touch: true

  validates :start_date, :end_date,
            presence: { message: I18n.t('errors.messages.blank_for_hs') }

  validates :opens_at, :closes_at,
            presence: { message: I18n.t('errors.messages.blank_for_hs_open') },
            unless: ->(hs) { hs.closed? }
end
