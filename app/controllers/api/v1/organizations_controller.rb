module Api
  module V1
    class OrganizationsController < ApplicationController

      caches :index, :show, :search, :caches_for => 5.minutes

      def index
        expose Organization.paginate(:page => params[:page], :per_page => 30)
      end

      def show
        expose Organization.find(params[:id])
      end

      def search
        if query_valid?(params[:location])
          begin
            result = find_by_keyword_and_location(params[:keyword], params[:location], current_radius, params[:sort])
            expose result.all.paginate(:page => params[:page], :per_page => 30)
          rescue Moped::Errors::OperationFailure
            error! :bad_request, :metadata => {:specific_reason => "Invalid ZIP code or address"}
          end
        else
          error! :bad_request, :metadata => {:specific_reason => "Invalid ZIP code or address"}
        end
      end
    end
  end
end