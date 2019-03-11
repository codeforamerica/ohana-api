class Event < ActiveRecord::Base
  MAX_EVENTS_FEATURED_MONTH = 3
  attr_accessible :title, :posted_at, :starting_at, :ending_at, :street_1,
                  :street_2, :city, :state_abbr, :zip, :phone, :external_url,
                  :organization_id, :is_featured, :body, :user_id

  belongs_to :user
  belongs_to :organization

  validates :title, presence: true
  validates :user_id, presence: true
  validates :starting_at, presence: true
  validates :ending_at, presence: true
  validates :street_1, presence: true
  validates :city, presence: true
  validate :three_events_in_month?

  paginates_per 200

  def three_events_in_month?
    featured_events_in_month = Event.events_in_month(self.starting_at)
                                .where(is_featured: true)
    if self.is_featured && featured_events_in_month.count >= MAX_EVENTS_FEATURED_MONTH
      errors.add(:starting_at, I18n.t('errors.messages.three_events_in_month'))
    end
  end

  def self.events_in_month(starting_at)
    where(
      'starting_at >= ? AND starting_at <= ?',
      starting_at.beginning_of_month,
      starting_at.end_of_month
    )
  end

  def self.with_orgs(ids)
    joins(:organization).where('organization_id IN (?)', ids).uniq
  end
end
