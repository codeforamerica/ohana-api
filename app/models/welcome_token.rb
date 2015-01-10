class WelcomeToken < ActiveRecord::Base
  after_create :set_code

  ENTITIES = %W{
    address
    location
    phone
    service
    contact
    mail_address
    program
    taxonomy
    holiday_schedule
    organization
    regular_schedule
  }

  def set_code
    # Create a unique hash for this token
    update_attribute :code, SecureRandom.uuid
  end
end
