module Api
  module V1
    class ErrorsController < ApplicationController
      def raise_not_found!
        message = "No route matches #{params[:unmatched_route]}"
        fail ActionController::RoutingError, message
      end
    end
  end
end
