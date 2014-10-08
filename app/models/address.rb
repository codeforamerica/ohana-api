class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates :street,
            :city,
            :state,
            :zip,
            presence: { message: I18n.t('errors.messages.blank_for_address') }

  validates :state,
            length: {
              maximum: 2,
              minimum: 2,
              message: I18n.t('errors.messages.invalid_state')
            }

  validates :zip, zip: true

  auto_strip_attributes :street, :city, :state, :zip, squish: true

  after_destroy :reset_location_coordinates

  private

  def reset_location_coordinates
    location.update!(latitude: nil, longitude: nil)
  end
end
