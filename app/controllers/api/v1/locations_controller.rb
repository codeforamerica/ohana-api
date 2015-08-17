require 'new_relic/agent/method_tracer'

module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors
      include Cacheable
      include ::NewRelic::Agent::MethodTracer

      after_action :set_cache_control, only: [:index, :show]

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
        location = Location.includes(
          contacts: :phones,
          services: [:categories, :contacts, :phones, :regular_schedules,
                     :holiday_schedules]
        ).find(params[:id])
        render json: location, status: 200 if stale?(location, public: true)
      end

      add_method_tracer :show, 'LocationsController/show'

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

      private

      def tables
        return [:organization, :address, :phones] unless request.format == Mime::XML
        [:address, :mail_address, :services, :organization,
         { contacts: :phones, services: common_tables }] + common_tables
      end

      def common_tables
        [:contacts, :phones, :regular_schedules, :holiday_schedules]
      end
    end
  end
end
