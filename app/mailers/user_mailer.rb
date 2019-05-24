class UserMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def new_registration(user)
    @user = user
    mail(to: user.email, subject: "Successful registration: Here is your new account info") if user.email.present?
  end
end
