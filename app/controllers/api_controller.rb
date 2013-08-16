class ApiController < RocketPants::Base

  #The "ApiPagination" module from the "api-pagination" gem only gets included
  #in ActionController::Base by default, but we're using RocketPants::Base
  #instead, so we have to explicitly include it here. This is required
  #for the after_filter in organizations_controller.rb to work
  include ApiPagination

  map_error! Mongoid::Errors::DocumentNotFound, RocketPants::NotFound

end
