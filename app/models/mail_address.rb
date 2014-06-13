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

  normalize_attributes :street, :city, :state, :zip

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :attention
    expose :street
    expose :city
    expose :state
    expose :zip
  end
end
