class Contact < ActiveRecord::Base
  include ParentPresenceValidatable

  default_scope { order('id ASC') }

  belongs_to :location, touch: true
  belongs_to :organization
  belongs_to :service, touch: true

  has_many :phones, dependent: :destroy, inverse_of: :contact
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_contact') }

  validates :email, email: true, allow_blank: true

  auto_strip_attributes :department, :email, :name, :title, squish: true
end
