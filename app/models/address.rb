class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates_presence_of :street, :city, :state, :zip,
                        message: "can't be blank for Address"

  validates_length_of :state,
                      maximum: 2, minimum: 2,
                      message: 'Please enter a valid 2-letter state abbreviation'

  validates_formatting_of :zip,
                          using: :us_zip,
                          allow_blank: true,
                          message: '%{value} is not a valid ZIP code'

  normalize_attributes :street, :city, :state, :zip

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :street
    expose :city
    expose :state
    expose :zip
  end
end
