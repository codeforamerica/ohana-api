class OrganizationApprovementMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def notify(organization)
    @organization = organization
    mail(to: organization.user.email, subject: "Your organization got approved!")
  end
end