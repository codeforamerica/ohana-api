class WelcomeToken < ActiveRecord::Base
  after_create :set_code

  ENTITIES = %W{
    organization
    location
    service
    program
    category
    contact
    phone
    mail_address
    holiday_schedule
    regular_schedule
  }

  def set_code
    # Create a unique hash for this token
    update_attribute :code, SecureRandom.uuid
  end
end
