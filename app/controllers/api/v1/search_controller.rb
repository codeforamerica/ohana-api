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
      end

      def nearby
        location = Location.find(params[:location_id])
        radius = Location.validated_radius(params[:radius], 0.5)

        nearby =
          if location.coordinates.present?
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
        if params[:org_name].present? && params[:location].present?
          [:address, :phones]
        else
          [:organization, :address, :phones]
        end
      end
    end
  end
end
