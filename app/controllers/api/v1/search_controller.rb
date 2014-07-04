module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors

      def index
        locations = Location.text_search(params).uniq.page(params[:page]).
                            per(params[:per_page]).
                            includes(:organization, :address, :phones)

        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
      end

      def nearby
        location = Location.find(params[:location_id])
        if params[:radius].present?
          radius = Location.validated_radius(params[:radius])
        else
          radius = 0.5
        end

        if location.latitude.present? && location.longitude.present?
          nearby = location.nearbys(radius).
                            page(params[:page]).per(params[:per_page]).
                            includes(:organization, :address, :phones)
        else
          nearby = Location.none.page(params[:page]).per(params[:per_page])
        end

        render json: nearby, status: 200
        generate_pagination_headers(nearby)
      end
    end
  end
end
