module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      def index
        locations = Location.search(params).page(params[:page]).
                    per(params[:per_page])

        render json: locations.preload(tables), each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
        expires_in cache_time, public: true
      end

      def nearby
        location = Location.find(params[:location_id])

        render json: [] and return if location.latitude.blank?

        render json: locations_near(location), each_serializer: NearbySerializer, status: 200
        generate_pagination_headers(locations_near(location))
      end

      private

      def tables
        if params[:org_name].present? && params[:location].present?
          [:address, :phones]
        else
          [:organization, :address, :phones]
        end
      end

      def locations_near(location)
        location.nearbys(params[:radius]).status('active').
          page(params[:page]).per(params[:per_page]).includes(:address)
      end
    end
  end
end
