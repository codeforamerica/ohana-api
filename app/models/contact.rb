class Contact < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :email, :extension, :fax, :name, :phone, :title

  belongs_to :location, touch: true

  validates :name, :title,
            presence: { message: I18n.t('errors.messages.blank_for_contact') }

  validates :email, email: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :fax, fax: true, allow_blank: true

  auto_strip_attributes :email, :extension, :fax, :name, :phone, :title, squish: true
end
