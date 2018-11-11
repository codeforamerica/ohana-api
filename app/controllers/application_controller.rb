require Rails.root.join('lib', 'default_host.rb')

class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception (with: :exception),
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  def after_sign_in_path_for(resource)
    return root_url if resource.is_a?(User)
    return admin_dashboard_url if resource.is_a?(Admin)
  end

  def after_sign_out_path_for(resource)
    return root_url if resource == :user
    return new_admin_session_url if resource == :admin
  end

  layout :layout_by_resource

  def pundit_user
    current_admin
  end

  def default_url_options
    { host: DefaultHost.new.call(request) }
  end

  private

  def render_not_found
    hash =
      {
        'status' => 404,
        'message' => 'The requested resource could not be found.',
        'documentation_url' => 'http://codeforamerica.github.io/ohana-api-docs/'
      }
    render json: hash, status: :not_found
  end

  def user_not_authorized
    flash[:error] = I18n.t('admin.not_authorized')
    redirect_to(request.referer || admin_dashboard_url)
  end

  protected

  def layout_by_resource
    return 'application' unless devise_controller? && resource_name == :admin

    'admin'
  end
end
