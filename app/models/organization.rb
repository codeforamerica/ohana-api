class Organization < ActiveRecord::Base
  default_scope { order('id DESC') }

  attr_accessible :alternate_name, :date_incorporated, :description, :email,
                  :legal_status, :name, :tax_id, :tax_status, :website

  has_many :locations, dependent: :destroy
  has_many :programs, dependent: :destroy

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_org') },
            uniqueness: { case_sensitive: false }

  validates :description,
            presence: { message: I18n.t('errors.messages.blank_for_org') }

  validates :email, email: true, allow_blank: true
  validates :website, url: true, allow_blank: true

  auto_strip_attributes :alternate_name, :description, :email, :legal_status,
                        :name, :tax_id, :tax_status, :website

  extend FriendlyId
  friendly_id :name, use: [:history]

  after_save :touch_locations, if: :name_changed?

  private

  def touch_locations
    locations.find_each(&:touch)
  end
end
