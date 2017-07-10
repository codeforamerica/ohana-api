class Phone < ActiveRecord::Base
  include ParentPresenceValidatable

  default_scope { order('id ASC') }

  attr_accessible :country_prefix, :department, :extension, :number,
                  :number_type, :vanity_number

  belongs_to :location, touch: true
  belongs_to :contact, touch: true
  belongs_to :service, touch: true
  belongs_to :organization

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_phone') },
            phone: { allow_blank: true, unless: ->(phone) { phone.number == '711' } }

  validates :number_type,
            presence: { message: I18n.t('errors.messages.blank_for_phone') }

  validates :extension, numericality: { allow_nil: true }

  auto_strip_attributes :country_prefix, :department, :extension, :number,
                        :vanity_number, squish: true

  extend Enumerize
  enumerize :number_type, in: %i[fax hotline sms tty voice]
end
