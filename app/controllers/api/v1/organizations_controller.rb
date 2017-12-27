module Api
  module V1
    class OrganizationsController < ApplicationController
      include TokenValidator
      include PaginationHeaders
      include CustomErrors

      def index
        orgs = Organization.includes(:contacts, :phones).
               page(params[:page]).per(params[:per_page])
        render json: orgs, status: 200
        generate_pagination_headers(orgs)
      end

      def show
        org = Organization.find(params[:id])
        render json: org, status: 200
      end

      def update
        org = Organization.find(params[:id])
        org.update!(org_params)
        render json: org, status: 200
      end

      def create
        org = Organization.create!(org_params)
        render json: org, status: 201, location: [:api, org]
      end

      def destroy
        org = Organization.find(params[:id])
        org.destroy
        head 204
      end

      def locations
        org = Organization.find(params[:organization_id])
        locations = org.locations.includes(:address, :phones).
                    page(params[:page]).per(params[:per_page])
        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
      end

      private

      def org_params
        params.require(:organization).permit(
          { accreditations: [] }, :alternate_name, :date_incorporated, :description,
          :email, { funding_sources: [] }, :legal_status, { licenses: [] }, :name,
          :tax_id, :tax_status, :website
        )
      end
    end
  end
end
