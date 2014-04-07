class Phone < ActiveRecord::Base
  belongs_to :location, touch: true

  normalize_attributes :department, :extension, :number, :vanity_number

  validates_presence_of :number

  validates_formatting_of :number, :using => :us_phone,
    message: "%{value} is not a valid US phone number"

  attr_accessible :department, :extension, :number, :vanity_number

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :department, :unless => lambda { |o,_| o.department.blank? }
    expose :extension, :unless => lambda { |o,_| o.extension.blank? }
    expose :number, :unless => lambda { |o,_| o.number.blank? }
    expose :vanity_number, :unless => lambda { |o,_| o.vanity_number.blank? }
  end

end
