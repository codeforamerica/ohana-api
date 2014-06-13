class Phone < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :department, :extension, :number, :number_type,
                  :vanity_number

  belongs_to :location, touch: true

  validates :number,
            presence: { message: "can't be blank for Phone" },
            phone: { unless: ->(phone) { phone.number == '711' } }

  auto_strip_attributes :department, :extension, :number, :number_type,
                        :vanity_number, squish: true

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
