class WelcomeToken < ActiveRecord::Base
  after_create :set_code

  def set_code
    # create a unique hash for this token
    update_attribute :code, SecureRandom.uuid
  end
end
