class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception (with: :exception),
  # or, for APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # This is to prevent the app from returning a 500 Internal Server Error
  # when a valid Accept Header is passed to a non-API URL, such as the
  # home page. This was causing some Ohanakapa wrapper specs to fail.
  # This is a bug in Rails and this workaround came from this issue:
  # https://github.com/rails/rails/issues/4127#issuecomment-10247450
  rescue_from ActionView::MissingTemplate, with: :missing_template

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  def after_sign_in_path_for(resource)
    return root_url if resource.is_a?(User)
    return admin_dashboard_path if resource.is_a?(Admin)
  end

  def after_sign_out_path_for(resource)
    return root_path if resource == :user
    return admin_dashboard_path if resource == :admin
  end

  layout :layout_by_resource

  def pundit_user
    current_admin
  end

  private

  def missing_template(exception)
    if exception.is_a?(ActionView::MissingTemplate) &&
       !Collector.new(collect_mimes_from_class_level).negotiate_format(request)
      render nothing: true, status: 406
    else
      logger.error(exception)
      render_500
    end
  end

  def render_not_found
    hash =
      {
        'status'  => 404,
        'message' => 'The requested resource could not be found.',
        'documentation_url' => 'http://codeforamerica.github.io/ohana-api-docs/'
      }
    render json: hash, status: 404
  end

  def user_not_authorized
    flash[:error] = I18n.t('admin.not_authorized')
    redirect_to(request.referrer || admin_dashboard_path)
  end

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :user
      'application'
    elsif devise_controller? && resource_name == :admin
      'admin'
    else
      'application'
    end
  end
end
