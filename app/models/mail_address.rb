class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates :street,
            :city,
            :state,
            :zip,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :state,
            length: {
              maximum: 2,
              minimum: 2,
              message: I18n.t('errors.messages.invalid_state')
            }

  validates :zip, zip: true

  auto_strip_attributes :attention, :street, :city, :state, :zip, squish: true

  include TrackChanges
end
