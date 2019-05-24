class OrganizationApprovementMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def notify(organization)
    if organization.user.present?
      @organization = organization
      mail(to: organization.user.email, subject: "Your organization got approved!")
    end
  end
end