class SuperAdminMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def new_registration(user)
    @user = user
    mail(
      to: ENV.fetch('ORGANIZATION_ADMIN_EMAIL'),
      subject: 'New registration pending for approvement'
    )
  end
end
