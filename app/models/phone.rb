class Phone < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :country_prefix, :department, :extension, :number,
                  :number_type, :vanity_number

  belongs_to :location, touch: true
  belongs_to :contact, touch: true

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_phone') },
            phone: { unless: ->(phone) { phone.number == '711' } }

  validates :number_type,
            presence: { message: I18n.t('errors.messages.blank_for_phone') }

  auto_strip_attributes :country_prefix, :department, :extension, :number,
                        :vanity_number, squish: true

  extend Enumerize
  enumerize :number_type, in: [:fax, :hotline, :tty, :voice]
end
