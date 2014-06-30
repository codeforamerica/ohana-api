require 'exceptions'

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

  unless Rails.application.config.consider_all_requests_local
    # rescue_from StandardError, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
    rescue_from ActiveRecord::SerializationTypeMismatch, with: :render_invalid_type
    rescue_from Exceptions::InvalidRadius, with: :render_invalid_radius
    rescue_from Exceptions::InvalidLatLon, with: :render_invalid_lat_lon
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
        'documentation_url' => docs_url
      }
    render json: hash, status: 404
  end

  def render_invalid_record(exception)
    hash =
      {
        'status'  => 422,
        'message' => 'Validation failed for resource.',
        'errors' => [exception.record.errors]
      }
    render json: hash, status: 422
  end

  def render_invalid_type(exception)
    value = exception.message.split('-- ').last
    hash =
      {
        'status'  => 422,
        'message' => 'Validation failed for resource.',
        'error' => "Attribute was supposed to be an Array, but was a String: #{value}."
      }
    render json: hash, status: 422
  end

  def render_invalid_radius
    message = {
      status: 400,
      error: 'Argument Error',
      description: 'Radius must be a Float between 0.1 and 50.'
    }
    render json: message, status: 400
  end

  def render_invalid_lat_lon
    message = {
      status: 400,
      error: 'Argument Error',
      description: 'lat_lng must be a comma-delimited lat,long pair of floats.'
    }
    render json: message, status: 400
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

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
