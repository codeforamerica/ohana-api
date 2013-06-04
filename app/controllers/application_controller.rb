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

  def find_by_keyword_and_location(keyword, location, radius, sort)
    if keyword.blank? && location.blank?
      error! :bad_request, :metadata => {:specific_reason => "Search requires the presence of at least one of the
                                                              following parameters: keyword or location"}
    elsif keyword.blank? && location.present?
      if sort == "name"
        Organization.near(location, radius).order_by(:name => :asc)
      else
        Organization.near(location, radius)
      end
    elsif keyword.present? && location.present?
      if sort == "name"
        Organization.find_by_keyword(keyword).find_by_location(location, radius).order_by(:name => :asc)
      else
        Organization.find_by_keyword(keyword).find_by_location(location, radius)
      end
    else
      if sort.blank?
        Organization.find_by_keyword(keyword).order_by(:name => :asc)
      elsif (sort == "asc" || sort == "desc")
        Organization.find_by_keyword(keyword).order_by(:name => sort.to_sym)
      else
        error! :bad_request, :metadata => {:specific_reason => "When the location parameter is not present,
                                                              the results are sorted alphabetically by default
                                                              in ascending order. The only accepted values for 
                                                              the sort parameter in this case are 'asc' or 'desc'."}
      end
    end  
  end
end
