require 'exceptions'

module CustomErrors
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Rescuable

    unless Rails.application.config.consider_all_requests_local
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
      rescue_from ActiveRecord::SerializationTypeMismatch, with: :render_invalid_type
      rescue_from Exceptions::InvalidRadius, with: :render_invalid_radius
      rescue_from Exceptions::InvalidLatLon, with: :render_invalid_lat_lon
    end
  end

  private

  def render_invalid_record(exception)
    hash =
      {
        'status'  => 422,
        'message' => 'Validation failed for resource.',
        'errors' => [exception.record.errors]
      }
    render json: hash, status: 422
  end

  def render_invalid_type
    hash =
      {
        status: 422,
        message: 'Validation failed for resource.',
        error: 'Attribute was supposed to be an Array, but was a String.'
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
end
