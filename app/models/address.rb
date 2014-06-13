class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates :street,
            :city,
            :state,
            :zip,
            presence: { message: "can't be blank for Address" }

  validates :state,
            length: {
              maximum: 2,
              minimum: 2,
              message: 'Please enter a valid 2-letter state abbreviation'
            }

  validates :zip, zip: true

  auto_strip_attributes :street, :city, :state, :zip, squish: true

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :street
    expose :city
    expose :state
    expose :zip
  end
end
