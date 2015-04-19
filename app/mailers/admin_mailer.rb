class AdminMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def existing_email_signup(resource)
    @portal = portal_for(resource)
    @sign_in_url = sign_in_url_for(resource)
    @sign_up_url = sign_up_url_for(resource)
    @password_url = password_url_for(resource)
    mail(to: resource.email, subject: "Request to sign up on #{@portal}")
  end

  def portal_for(resource)
    return t('titles.admin', brand: t('titles.brand')) if resource.is_a?(Admin)
    return t('titles.developer', brand: t('titles.brand')) if resource.is_a?(User)
  end

  def sign_in_url_for(resource)
    return new_admin_session_url(subdomain: ENV['ADMIN_SUBDOMAIN']) if resource.is_a?(Admin)
    return new_user_session_url(subdomain: ENV['DEV_SUBDOMAIN']) if resource.is_a?(User)
  end

  def sign_up_url_for(resource)
    return new_admin_registration_url(subdomain: ENV['ADMIN_SUBDOMAIN']) if resource.is_a?(Admin)
    return new_user_registration_url(subdomain: ENV['DEV_SUBDOMAIN']) if resource.is_a?(User)
  end

  def password_url_for(resource)
    return new_admin_password_url(subdomain: ENV['ADMIN_SUBDOMAIN']) if resource.is_a?(Admin)
    return new_user_password_url(subdomain: ENV['DEV_SUBDOMAIN']) if resource.is_a?(User)
  end
end
