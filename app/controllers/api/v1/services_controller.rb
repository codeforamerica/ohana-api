module Api
  module V1
    class ServicesController < ApplicationController
      include TokenValidator
      include CustomErrors
      include CategoryIdCollector

      before_action :validate_token!, only: [:update, :destroy, :create, :update_categories]

      def index
        location = Location.includes(
          services: [:categories, :contacts, :phones, :regular_schedules,
                     :holiday_schedules]).find(params[:location_id])
        services = location.services
        render json: services, status: 200
      end

      def update
        service = Service.find(params[:id])
        service.update!(params)
        render json: service, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        service = location.services.create!(params)
        render json: service, status: 201
      end

      def destroy
        service = Service.find(params[:id])
        service.destroy
        head 204
      end

      def update_categories
        service = Service.find(params[:service_id])
        service.category_ids = cat_ids(params[:taxonomy_ids])
        service.save!

        render json: service, status: 200
      end
    end
  end
end
