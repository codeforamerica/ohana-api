class Phone < ActiveRecord::Base
  belongs_to :location, touch: true

  normalize_attributes :department, :extension, :number, :number_type,
                       :vanity_number

  validates_presence_of :number, message: "can't be blank for Phone"

  validates_formatting_of(
    :number,
    using: :us_phone,
    message: '%{value} is not a valid US phone number',
    unless: ->(phone) { phone.number == '711' }
  )

  attr_accessible :department, :extension, :number, :number_type,
                  :vanity_number

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :department, unless: ->(o, _) { o.department.blank? }
    expose :extension, unless: ->(o, _) { o.extension.blank? }
    expose :number, unless: ->(o, _) { o.number.blank? }
    expose :number_type, unless: ->(o, _) { o.number_type.blank? }
    expose :vanity_number, unless: ->(o, _) { o.vanity_number.blank? }
  end
end
