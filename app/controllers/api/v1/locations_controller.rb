module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      def index
        locations = Location.includes(:organization, :address, :phones).
                    page(params[:page]).per(params[:per_page]).
                    order('created_at DESC')

        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
      end

      def show
        location = Location.includes(
          contacts: :phones,
          services: [:categories, :contacts, :phones, :regular_schedules,
                     :holiday_schedules]
          ).find(params[:id])
        render json: location, status: 200
        expires_in cache_time, public: true
      end

      def update
        location = Location.find(params[:id])
        location.update!(params)
        render json: location, status: 200
      end

      def create
        org = Organization.find(params[:organization_id])
        location = org.locations.create!(params)
        response_hash = {
          id: location.id,
          name: location.name,
          slug: location.slug
        }
        render json: response_hash, status: 201, location: [:api, location]
      end

      def destroy
        location = Location.find(params[:id])
        location.destroy
        head 204
      end
    end
  end
end
