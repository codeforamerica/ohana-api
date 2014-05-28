class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state, :street, :zip

  belongs_to :location, touch: true

  normalize_attributes :street, :city, :state, :zip

  validates_presence_of :street,
                        :city,
                        :state,
                        :zip,
                        message: "can't be blank for Mail Address"

  validates_length_of :state,
                      maximum: 2,
                      minimum: 2,
                      message: 'Please enter a valid 2-letter state abbreviation'

  validates_formatting_of :zip,
                          using: :us_zip,
                          allow_blank: true,
                          message: '%{value} is not a valid ZIP code'

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
