RSpec.configure do |config|
  config.before(:each, email: true) do
    ActionMailer::Base.deliveries = []
  end
end

module MailerMacros
  def first_email
    ActionMailer::Base.deliveries.first
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end
