module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: %i[index show]

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
          services: %i[categories contacts phones regular_schedules
                       holiday_schedules]
        ).find(params[:id])
        render json: location, status: 200 if stale?(location, public: true)
      end

      def update
        location = Location.find(params[:id])
        location.update!(location_params)
        render json: location, status: 200
      end

      def create
        org = Organization.find(params[:organization_id])
        location = org.locations.create!(location_params)
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

      private

      def location_params
        params.permit(
          { accessibility: [] }, :active, { admin_emails: [] }, :alternate_name, :description,
          :email, { languages: [] }, :latitude, :longitude, :name, :short_desc,
          :transportation, :website, :virtual,
          address_attributes: %i[
            address_1 address_2 city state_province postal_code
            country id _destroy
          ]
        )
      end
    end
  end
end
