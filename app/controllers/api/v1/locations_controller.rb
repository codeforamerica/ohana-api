module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: %i[index show]

      respond_to :xml

      def index
        @locations = Location.includes(tables).paginated_and_sorted(params)

        respond_to do |format|
          format.json { render json: @locations, each_serializer: LocationsSerializer, status: 200 }
          format.xml { respond_with @locations }
        end

        generate_pagination_headers(@locations)
      end

      def show
        location = Location.includes(show_tables).find(params[:id])

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

      def tables
        return %i[organization address phones] unless request.format == Mime[:xml]
        [:address, :mail_address, :services, :organization,
         { contacts: :phones, services: common_tables }] + common_tables
      end

      def common_tables
        @common_tables ||= %i[contacts phones regular_schedules holiday_schedules]
      end

      def show_tables
        @show_tables ||= [
          {
            contacts: :phones,
            services: %i[categories contacts phones regular_schedules holiday_schedules]
          }
        ]
      end

      def location_params
        params.permit(
          { accessibility: [] }, :active, { admin_emails: [] }, :alternate_name,
          :description, :email, :hours, :kind, { languages: [] }, :latitude,
          :longitude, :market_match, :name, { payments: [] }, { products: [] },
          :short_desc, :transportation, :website, :virtual,
          address_attributes: %i[
            address_1 address_2 city state_province postal_code
            country id _destroy
          ]
        )
      end
    end
  end
end
