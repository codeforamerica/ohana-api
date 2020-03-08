class Address < ApplicationRecord
  belongs_to :location, optional: true, touch: true

  validates :address_1,
            :city,
            :postal_code,
            :country,
            presence: { message: I18n.t('errors.messages.blank_for_address') }

  validates :state_province, state_province: true

  validates :country, length: { allow_blank: true, maximum: 2, minimum: 2 }

  validates :postal_code, zip: { allow_blank: true }

  auto_strip_attributes :address_1, :address_2, :city, :state_province, :postal_code,
                        :country, squish: true

  after_destroy :reset_location_coordinates

  private

  def reset_location_coordinates
    location.update(latitude: nil, longitude: nil)
  end
end
