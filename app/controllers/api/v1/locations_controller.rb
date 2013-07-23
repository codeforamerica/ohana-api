module Api
  module V1
    class LocationsController < ApiController

      caches :index, :show, :search, :nearby, :caches_for => 5.minutes

      def index
        locs = Location.page(params[:page]).per(30)
        expose locs
      end

      def show
        loc = Location.find(params[:id])
        expose loc
      end

      def search
        @results = org_search(params).all.page(params[:page]).per(30)
        begin
          expose @results
        rescue Moped::Errors::QueryFailure
          error! :bad_request,
                 :metadata => {
                   :specific_reason => "Invalid ZIP code or address"
                 }
        end
      end

      def nearby
        loc = Location.find(params[:id])
        expose loc.nearbys(current_radius)
      end
    end
  end
end