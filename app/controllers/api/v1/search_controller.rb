module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors

      def index
        locations = Location.search(params).page(params[:page]).
                            per(params[:per_page]).
                            includes(tables)

        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
        expires_in ENV['EXPIRES_IN'].to_i.minutes, public: true
      end

      def nearby
        location = Location.find(params[:location_id])

        render json: [] and return if location.coordinates.blank?

        radius = Location.validated_radius(params[:radius], 0.5)

        nearby = location.nearbys(radius).status('active').
                         page(params[:page]).per(params[:per_page]).
                         includes(:address)

        render json: nearby, each_serializer: NearbySerializer, status: 200
        generate_pagination_headers(nearby)
      end

      private

      def tables
        if params[:org_name].present? && params[:location].present?
          [:address, :phones]
        else
          [:organization, :address, :phones]
        end
      end
    end
  end
end
