class Event < ActiveRecord::Base
  attr_accessible :title, :posted_at, :starting_at, :ending_at, :street_1,
                  :street_2, :city, :state_abbr, :zip, :phone, :external_url,
                  :organization_id, :is_featured, :body, :admin_id

  belongs_to :admin
  belongs_to :organization

  def self.events_in_month(month)
    where('EXTRACT(MONTH FROM starting_at) = ?', month)
  end

  def self.with_orgs(ids)
    joins(:organization).where('organization_id IN (?)', ids).uniq
  end
end
