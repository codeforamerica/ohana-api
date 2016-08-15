require 'exceptions'

class LocationFilter
  class << self
    delegate :call, to: :new
  end

  def initialize(model_class = Location)
    @model_class = model_class
  end

  def call(location, lat_lng, radius)
    return @model_class.all if location.blank? && lat_lng.blank? && radius.blank?
    @model_class.near(coords(location, lat_lng), validated_radius(radius, 5))
  end

  def validated_radius(radius, custom_radius)
    return custom_radius unless radius.present?

    raise Exceptions::InvalidRadius if radius.to_f == 0.0

    # radius must be between 0.1 miles and 50 miles
    [[0.1, radius.to_f].max, 50].min
  end

  private

  def result_for(location)
    Geocoder.search(location, bounds: SETTINGS[:bounds])
  end

  def coords(location, lat_lng)
    if location.present? && result_for(location).present?
      return result_for(location).first.coordinates
    end
    return validated_coordinates(lat_lng) if lat_lng.present?
  end

  def validated_coordinates(lat_lng)
    lat, lng = lat_lng.split(',')
    raise Exceptions::InvalidLatLon if lat.to_f == 0.0 || lng.to_f == 0.0
    [Float(lat), Float(lng)]
  end
end
