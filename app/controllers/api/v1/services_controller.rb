module Api
  module V1
    class ServicesController < Api::V1::BaseController
      include CustomErrors
      include CategoryIdCollector
      include ErrorSerializer

      before_action :authenticate_api_user!, except: [:index]

      def index
        location = Location.includes(
          services: %i[categories contacts phones regular_schedules
                       holiday_schedules]
        ).find(params[:location_id])
        services = location.services
        render json: services, status: 200
      end

      def show
        render json: service, serializer: ServiceSerializer, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        service = location.services.build(service_params.except(:taxonomy_ids))
        if location.save
          update_categories(service)
          render json: service, status: 201
        else
          render json: ErrorSerializer.serialize(service.errors),
                 status: :unprocessable_entity
        end
      end

      def update
        if service.update(service_params)
          update_categories(service)
          render json: service,
                 serializer: ServiceSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(service.errors),
                 status: :unprocessable_entity
        end
      end

      def destroy
        service.destroy
        head 204
      end

      def update_categories(service)
        service.update category_ids:cat_ids(params[:taxonomy_ids])
      end

      private

      def service
        @service ||= Service.find params[:id]
      end

      def service_params
        params.require(:service).permit(
          :alternate_name,
          :audience,
          :description,
          :eligibility,
          :email,
          :fees,
          :application_process,
          :interpretation_services,
          :name,
          :status,
          :website,
          :wait_time,
          taxonomy_ids: [],
          required_documents: [],
          funding_sources: [],
          keywords: [],
          service_areas: [],
          accepted_payments: [],
          languages: [],
          regular_schedules_attributes: [
            :id,
            :opens_at,
            :closes_at,
            :weekday,
            :_destroy
          ],
          holiday_schedules_attributes: [
            :id,
            :closed,
            :start_date,
            :end_date,
            :opens_at,
            :closes_at,
            :_destroy
          ],
          phones_attributes: [
            :id,
            :department,
            :extension,
            :number,
            :number_type,
            :vanity_number,
            :_destroy
          ]
        )
      end
    end
  end
end
