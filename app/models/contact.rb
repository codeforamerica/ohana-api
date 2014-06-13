class Contact < ActiveRecord::Base
  attr_accessible :email, :extension, :fax, :name, :phone, :title

  belongs_to :location, touch: true

  validates :name, :title, presence: { message: "can't be blank for Contact" }
  validates :email, email: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :fax, fax: true, allow_blank: true

  normalize_attributes :name, :title, :email, :fax, :phone, :extension

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
