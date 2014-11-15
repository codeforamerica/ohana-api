class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state, :street_1, :street_2,
                  :postal_code, :country_code

  belongs_to :location, touch: true

  validates :street_1,
            :city,
            :state,
            :postal_code,
            :country_code,
            :location,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :state, length: { maximum: 2, minimum: 2 }

  validates :country_code, length: { maximum: 2, minimum: 2 }

  validates :postal_code, zip: true

  auto_strip_attributes :attention, :street_1, :street_2, :city, :state,
                        :postal_code, :country_code, squish: true
end
