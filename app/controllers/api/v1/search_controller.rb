module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: :index

      def index
        locations = Location.search(params).page(params[:page]).
                    per(params[:per_page])

        return unless stale?(etag: cache_key(locations), public: true)

        generate_pagination_headers(locations)
        render json: locations.preload(tables), each_serializer: LocationsSerializer, status: 200
      end

      def nearby
        location = Location.find(params[:location_id])

        render json: [] and return if location.latitude.blank?

        render json: locations_near(location), each_serializer: NearbySerializer, status: 200
        generate_pagination_headers(locations_near(location))
      end

      private

      def tables
        [:organization, :address, :phones]
      end

      def locations_near(location)
        location.nearbys(params[:radius]).status('active').
          page(params[:page]).per(params[:per_page]).includes(:address)
      end

      def cache_key(scope)
        Digest::MD5.hexdigest(
          "#{scope.to_sql}-#{scope.maximum(:updated_at)}-#{scope.total_count}"
        )
      end
    end
  end
end
