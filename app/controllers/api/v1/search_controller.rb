module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors

      def index
        locations = Location.search(params).
                             page(params[:page]).per(params[:per_page])

        expires_in ENV['EXPIRES_IN'].to_i.minutes, public: true
        if stale?(etag: cache_key(locations), public: true)
          generate_pagination_headers(locations)
          render json: locations.preload(tables), each_serializer: LocationsSerializer, status: 200
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

      def cache_key(scope)
        "#{scope.to_sql}-#{scope.maximum(:updated_at)}-#{scope.total_count}"
      end
    end
  end
end
