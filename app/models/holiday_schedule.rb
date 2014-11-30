class HolidaySchedule < ActiveRecord::Base
  attr_accessible :closed, :start_date, :end_date, :opens_at, :closes_at

  belongs_to :location, touch: true
  belongs_to :service, touch: true

  validates :start_date, :end_date,
            date: true,
            presence: { message: I18n.t('errors.messages.blank_for_hs') }

  validates :opens_at, :closes_at,
            presence: { message: I18n.t('errors.messages.blank_for_hs_open') },
            unless: ->(hs) { hs.closed? }

  validate :parent_presence

  private

  def parent_presence
    return if [location, service].any?(&:present?)
    errors[:base] << 'Holiday Schedule must belong to either a Location or Service'
  end
end
