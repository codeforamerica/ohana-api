class Address < ActiveRecord::Base
  attr_accessible :city, :state_province, :street_1, :street_2, :postal_code,
                  :country_code

  belongs_to :location, touch: true

  validates :street_1,
            :city,
            :state_province,
            :postal_code,
            :country_code,
            presence: true

  validates :state_province, length: { maximum: 2, minimum: 2 }

  validates :country_code, length: { maximum: 2, minimum: 2 }

  validates :postal_code, zip: true

  auto_strip_attributes :street_1, :street_2, :city, :state_province, :postal_code,
                        :country_code, squish: true

  after_destroy :reset_location_coordinates

  private

  def reset_location_coordinates
    location.update(latitude: nil, longitude: nil)
  end
end
