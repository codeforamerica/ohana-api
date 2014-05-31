class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception (with: :exception),
  # or, for APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # This is to prevent the app from returning a 500 Internal Server Error
  # when a valid Accept Header is passed to a non-API URL, such as the
  # home page. This was causing some Ohanakapa wrapper specs to fail.
  # This is a bug in Rails and this workaround came from this issue:
  # https://github.com/rails/rails/issues/4127#issuecomment-10247450
  rescue_from ActionView::MissingTemplate, with: :missing_template

  def missing_template(exception)
    if exception.is_a?(ActionView::MissingTemplate) &&
      !Collector.new(collect_mimes_from_class_level).negotiate_format(request)
      render nothing: true, status: 406
    else
      logger.error(exception)
      render_500
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
