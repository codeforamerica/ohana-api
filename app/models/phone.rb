class Phone < ActiveRecord::Base
  belongs_to :location, touch: true

  normalize_attributes :department, :extension, :number, :vanity_number

  validates_presence_of :number, message: "can't be blank for Phone"

  validates_formatting_of(
    :number,
    using: :us_phone,
    message: '%{value} is not a valid US phone number'
  )

  attr_accessible :department, :extension, :number, :vanity_number

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :department, unless: ->(o, _) { o.department.blank? }
    expose :extension, unless: ->(o, _) { o.extension.blank? }
    expose :number, unless: ->(o, _) { o.number.blank? }
    expose :vanity_number, unless: ->(o, _) { o.vanity_number.blank? }
  end
end
