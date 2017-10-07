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
        org.update!(params)
        render json: org, status: 200
      end

      def create
        org = Organization.create!(params)
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

      def search
        puts params
        organizations = Organization.find_organizations_that_have_any_of_these_categories(params[:category])
        puts organizations.to_sql
        render json: organizations.count, status: 201
      end
    end
  end
end
