module Api
  module V1
    class ServicesController < ApplicationController
      include TokenValidator
      include CustomErrors

      before_action :validate_token!, only: %i[update destroy create update_categories]
      before_action :validate_service_areas, only: %i[update create]

      def index
        location = Location.includes(
          services: %i[categories contacts phones regular_schedules
                       holiday_schedules]
        ).find(params[:location_id])
        services = location.services
        render json: services, status: 200
      end

      def update
        service = Service.find(params[:id])
        service.update!(service_params)
        render json: service, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        service = location.services.create!(service_params)
        render json: service, status: 201
      end

      def destroy
        service = Service.find(params[:id])
        service.destroy
        head 204
      end

      def update_categories
        service = Service.find(params[:service_id])
        service.category_ids = cat_ids(service_params[:taxonomy_ids])
        service.save!

        render json: service, status: 200
      end

      private

      def cat_ids(taxonomy_ids)
        return [] if taxonomy_ids.blank?
        Category.where(taxonomy_id: taxonomy_ids).pluck(:id)
      end

      def validate_service_areas
        render_invalid_type if params[:service_areas].is_a?(String)
      end

      def service_params
        params.permit(
          { accepted_payments: [] }, :alternate_name, :audience, :description,
          :eligibility, :email, :fees, { funding_sources: [] },
          :application_process, :interpretation_services, { keywords: [] },
          { languages: [] }, :name, { required_documents: [] },
          { service_areas: [] }, :status, :website, :wait_time, taxonomy_ids: []
        )
      end
    end
  end
end
