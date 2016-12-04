module PrivateRegistration
  def create
    build_resource(sign_up_params)

    if resource.save
      process_successful_registration
    elsif resource_valid_except_for_duplicate_email?
      process_private_registration
    else
      resource.errors[:email].delete_if { |e| e == 'has already been taken' }
      process_unsuccessful_registration
    end
  end

  private

  def resource_valid_except_for_duplicate_email?
    resource_class.find_by(email: resource.email).present? &&
      only_email_error_is_duplicate?
  end

  def only_email_error_is_duplicate?
    resource.errors.keys == [:email] &&
      resource.errors[:email].uniq == ['has already been taken']
  end

  def process_private_registration
    AdminMailer.existing_email_signup(resource).deliver_now
    if is_flashing_format?
      set_flash_message :notice, :signed_up_but_unconfirmed, email: resource.email
    end
    redirect_to path_for(resource)
  end

  def path_for(resource)
    return new_admin_session_path if resource.is_a?(Admin)
    return new_user_session_path if resource.is_a?(User)
  end

  def process_successful_registration
    if is_flashing_format?
      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
    end
    expire_data_after_sign_in!
    respond_with resource, location: after_inactive_sign_up_path_for(resource)
  end

  def process_unsuccessful_registration
    clean_up_passwords resource
    @validatable = devise_mapping.validatable?
    if @validatable
      @minimum_password_length = resource_class.password_length.min
    end
    respond_with resource
  end
end
