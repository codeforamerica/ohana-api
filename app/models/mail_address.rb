class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates :street,
            :city,
            :state,
            :zip,
            presence: { message: "can't be blank for Mail Address" }

  validates :state,
            length: {
              maximum: 2,
              minimum: 2,
              message: 'Please enter a valid 2-letter state abbreviation'
            }

  validates :zip, zip: true

  auto_strip_attributes :attention, :street, :city, :state, :zip, squish: true
end
