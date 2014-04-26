class Contact < ActiveRecord::Base
  attr_accessible :email, :extension, :fax, :name, :phone, :title

  belongs_to :location, touch: true

  normalize_attributes :name, :title, :email, :fax, :phone, :extension

  validates_presence_of :name, :title, message: "can't be blank for Contact"

  validates_formatting_of :email,
                          with: /.+@.+\..+/i,
                          allow_blank: true, message: '%{value} is not a valid email'

  validates_formatting_of :phone,
                          using: :us_phone,
                          allow_blank: true,
                          message: '%{value} is not a valid US phone number'

  validates_formatting_of :fax,
                          using: :us_phone,
                          allow_blank: true,
                          message: '%{value} is not a valid US fax number'

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :name, unless: ->(o, _) { o.name.blank? }
    expose :title, unless: ->(o, _) { o.title.blank? }
    expose :phone, unless: ->(o, _) { o.phone.blank? }
    expose :email, unless: ->(o, _) { o.email.blank? }
    expose :fax, unless: ->(o, _) { o.fax.blank? }
  end
end
