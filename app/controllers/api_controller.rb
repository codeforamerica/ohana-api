class ApiController < RocketPants::Base

  #The "ApiPagination" module from the "api-pagination" gem only gets included
  #in ActionController::Base by default, but we're using RocketPants::Base
  #instead, so we have to explicitly include it here. This is required
  #for the after_filter in organizations_controller.rb to work
  include ApiPagination

  map_error! Mongoid::Errors::DocumentNotFound, RocketPants::NotFound

  private
  def current_radius
    if params[:radius].present?
      begin
        radius = Float params[:radius].to_s
        # radius must be between 0.1 miles and 10 miles
        [[0.1, radius].max, 10].min
      rescue ArgumentError
        error! :bad_request,
               :metadata => { :specific_reason => "radius must be a number" }
      end
    else
      2
    end
  end

  def org_search(params)
    organizations = scope_builder
    error! :bad_request,
           :metadata => {
           :specific_reason => "keyword and location can't both be blank"
           } if params[:keyword].blank? && params[:location].blank?

    organizations.find_by_keyword(params[:keyword]) if params[:keyword]
    organizations.find_near(params[:location], current_radius) unless params[:location].blank?
    organizations.order_by(:name => :asc) if params[:sort] == "name"
    organizations.order_by(:name => params[:order].to_sym) if params[:order]
    organizations
  end

  def scope_builder
    DynamicDelegator.new(Organization.scoped)
  end
end
