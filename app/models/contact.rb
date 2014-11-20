class Contact < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :department, :email, :name, :title, :phones_attributes

  belongs_to :location, touch: true
  belongs_to :organization
  belongs_to :service, touch: true

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_contact') }

  validates :email, email: true, allow_blank: true

  validate :parent_presence

  auto_strip_attributes :department, :email, :name, :title, squish: true

  private

  def parent_presence
    return if [location, organization, service].any?(&:present?)
    errors[:base] << 'Contact must belong to either a Location, Organization or Service'
  end
end
