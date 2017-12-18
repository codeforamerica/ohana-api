class MailAddress < ActiveRecord::Base
  belongs_to :location, touch: true, inverse_of: :mail_address

  validates :address_1,
            :city,
            :postal_code,
            :country,
            :location,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :state_province, state_province: true

  validates :country, length: { allow_blank: true, maximum: 2, minimum: 2 }

  validates :postal_code, zip: { allow_blank: true }

  auto_strip_attributes :attention, :address_1, :address_2, :city, :state_province,
                        :postal_code, :country, squish: true
end
