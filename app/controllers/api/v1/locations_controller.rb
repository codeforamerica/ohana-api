module Api
  module V1
    class LocationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors

      respond_to :xml

      def index
        @locations = Location.includes(tables).
                              page(params[:page]).per(params[:per_page]).
                              order('created_at DESC')

        respond_to do |format|
          format.json { render json: @locations, each_serializer: LocationsSerializer, status: 200 }
          format.xml { respond_with @locations }
        end

        generate_pagination_headers(@locations)
      end

      def show
        location = Location.find(params[:id])
        render json: location, status: 200
        expires_in ENV['EXPIRES_IN'].to_i.minutes, public: true
      end

      def update
        location = Location.find(params[:id])
        location.update!(params)
        render json: location, status: 200
      end

      def create
        location = Location.create!(params)
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
        [:address, :contacts, :faxes, :mail_address, :organization, :phones,
         :services]
      end
    end
  end
end
