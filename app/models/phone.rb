class Phone < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :country_prefix, :department, :extension, :number,
                  :number_type, :vanity_number

  belongs_to :location, touch: true
  belongs_to :contact, touch: true
  belongs_to :service, touch: true
  belongs_to :organization

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_phone') },
            phone: { unless: ->(phone) { phone.number == '711' } }

  validates :number_type,
            presence: { message: I18n.t('errors.messages.blank_for_phone') }

  validates :extension, numericality: { allow_nil: true }

  validate :parent_presence

  auto_strip_attributes :country_prefix, :department, :extension, :number,
                        :vanity_number, squish: true

  extend Enumerize
  enumerize :number_type, in: [:fax, :hotline, :tty, :voice]

  private

  def parent_presence
    return if [contact, location, organization, service].any?(&:present?)
    errors[:base] << 'Phone must belong to either a Contact, Location, Organization or Service'
  end
end
