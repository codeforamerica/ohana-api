class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state_province, :address_1, :address_2,
                  :postal_code, :country

  belongs_to :location, touch: true

  validates :address_1,
            :city,
            :postal_code,
            :country,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :state_province, state_province: true

  validates :country, length: { allow_blank: true, maximum: 2, minimum: 2 }

  validates :postal_code, zip: { allow_blank: true }

  auto_strip_attributes :attention, :address_1, :address_2, :city, :state_province,
                        :postal_code, :country, squish: true
end
