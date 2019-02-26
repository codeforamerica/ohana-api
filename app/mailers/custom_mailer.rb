class CustomMailer < Devise::Mailer
  def confirmation_instructions(record, token, options = {})
    options[:template_path] = template_path(record)
    super
  end

  def reset_password_instructions(record, token, options = {})
    options[:template_path] = template_path(record)
    super
  end

  private

  def template_path(resource)
    return 'admin/mailer' if resource.is_a?(Admin)
    return 'user_mailer' if resource.is_a?(User)
  end
end
