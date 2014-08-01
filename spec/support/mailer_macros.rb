module MailerMacros
  def first_email
    ActionMailer::Base.deliveries.first
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end
