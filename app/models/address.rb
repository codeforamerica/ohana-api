class Address < ActiveRecord::Base
  attr_accessible :city, :state_province, :address_1, :address_2, :postal_code,
                  :country

  belongs_to :location, touch: true

  validates :address_1,
            :city,
            :state_province,
            :postal_code,
            :country,
            presence: { message: I18n.t('errors.messages.blank_for_address') }

  validates :state_province, length: { maximum: 2, minimum: 2 }

  validates :country, length: { maximum: 2, minimum: 2 }

  validates :postal_code, zip: true

  auto_strip_attributes :address_1, :address_2, :city, :state_province, :postal_code,
                        :country, squish: true

  after_destroy :reset_location_coordinates

  private

  def reset_location_coordinates
    location.update(latitude: nil, longitude: nil)
  end
end
