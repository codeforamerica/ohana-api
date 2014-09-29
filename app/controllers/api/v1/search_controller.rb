module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors

      def index
        locations = Location.search(params).
                             page(params[:page]).per(params[:per_page])

        json = cache ['v1', locations] do
          render_to_string json: locations.preload(tables), each_serializer: LocationsSerializer
        end

        if stale?(locations, public: true)
          generate_pagination_headers(locations)
          render json: json, status: 200
        end
      end

      def nearby
        location = Location.find(params[:location_id])
        radius = Location.validated_radius(params[:radius], 0.5)

        nearby =
          if location.longitude.present? && location.latitude.present?
            location.nearbys(radius).
                    page(params[:page]).per(params[:per_page]).
                    includes(:organization, :address, :phones)
          else
            Location.none.page(params[:page]).per(params[:per_page])
          end

        render json: nearby, status: 200
        generate_pagination_headers(nearby)
      end

      private

      def tables
        [:organization, :address, :phones]
      end
    end
  end
end
