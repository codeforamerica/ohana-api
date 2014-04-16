class Fax < ActiveRecord::Base
  belongs_to :location, touch: true
  attr_accessible :number, :department

  validates_presence_of :number, message: "can't be blank for Fax"
  validates_formatting_of :number, :using => :us_phone,
    message: "%{value} is not a valid US fax number"

  normalize_attributes :number, :department

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :number, :unless => lambda { |o,_| o.number.blank? }
    expose :department, :unless => lambda { |o,_| o.department.blank? }
  end

end
