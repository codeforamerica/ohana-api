class Fax < ActiveRecord::Base
  attr_accessible :number, :department

  belongs_to :location, touch: true

  validates :number,
            presence: { message: "can't be blank for Fax" },
            fax: true

  auto_strip_attributes :number, :department, squish: true
end
