class Fax < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :number, :department

  belongs_to :location, touch: true

  validates :number,
            presence: { message: "can't be blank for Fax" },
            fax: true

  auto_strip_attributes :number, :department, squish: true
end
