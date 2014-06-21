module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders

      before_action :validate_token!, only: [:update, :destroy, :create]

      def index
        locations = Location.includes(:organization, :address, :mail_address, :contacts, :phones, :faxes, services: :categories).
                            page(params[:page]).per(params[:per_page]).
                            order('created_at DESC')

        render json: locations, status: 200
        generate_pagination_headers(locations)
      end

      def show
        location = Location.find(params[:id])
        render json: location, status: 200
      end

      def update
        location = Location.find(params[:id])
        location.update!(params)
        render json: location, status: 200, location: [:api, location]
      end

      def create
        location = Location.create!(params)
        render json: location, status: 201, location: [:api, location]
      end

      def destroy
        location = Location.find(params[:id])
        location.destroy
        head 204
      end
    end
  end
end
