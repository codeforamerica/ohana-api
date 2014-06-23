module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include TokenValidator

      TABLES = [
        :organization, :address, :mail_address, :contacts, :phones,
        :faxes, services: :categories
      ]

      def index
        TABLES.delete(:organization) if params[:org_name].present?
        TABLES.push(:services).delete(services: :categories) if params[:category].present?

        locations = Location.text_search(params).uniq.page(params[:page]).
                            per(params[:per_page]).includes(TABLES)

        render json: locations, status: 200
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
                            includes(TABLES)
        else
          nearby = Location.none.page(params[:page]).per(params[:per_page])
        end

        render json: nearby, status: 200
        generate_pagination_headers(nearby)
      end
    end
  end
end
