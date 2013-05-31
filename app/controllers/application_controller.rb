class ApplicationController < RocketPants::Base
  map_error! Mongoid::Errors::DocumentNotFound, RocketPants::NotFound
  
  private

  def current_radius
    if params[:radius].present?
      begin
        radius = Float params[:radius].to_s
        # radius must be between 0.1 miles and 10 miles
        [[0.1, radius].max, 10].min
      rescue ArgumentError
        error! :bad_request, :metadata => {:specific_reason => "radius must be a number"}
      end
    else
      2
    end
  end

  def query_valid?(address)
    if address =~ /(^\d{5}-+)/
      return false
    elsif address =~ /^\d+$/
      if address.length != 5
        return false
      else
        result = address.to_region
        if result.nil? 
          return false
        else
          return true
        end
      end
    else
      return true
    end
  end
end
