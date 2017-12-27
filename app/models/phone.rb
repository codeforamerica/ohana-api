class Phone < ActiveRecord::Base
  include ParentPresenceValidatable

  default_scope { order('id ASC') }

  belongs_to :location, touch: true, inverse_of: :phones
  belongs_to :contact, touch: true, inverse_of: :phones
  belongs_to :service, touch: true, inverse_of: :phones
  belongs_to :organization, inverse_of: :phones

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
