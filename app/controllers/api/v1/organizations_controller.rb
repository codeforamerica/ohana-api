module Api
  module V1
    class OrganizationsController < Api::V1::BaseController
      include PaginationHeaders
      include CustomErrors

      before_action :authenticate_api_user!, except: [:index, :show]

      def index
        organizations = Organization.filter_by_id(params[:id])
                                    .filter_by_categories(params[:category])
                                    .filter_by_location(
                                      params[:sw_lat],
                                      params[:sw_lng],
                                      params[:ne_lat],
                                      params[:ne_lng],
                                      params[:lat_attr],
                                      params[:lon_attr]
                                    )
                                    .rank()
                                    .page(params[:page])
                                    .per(params[:per_page])
        generate_pagination_headers(organizations)
        render json: organizations,
               each_serializer: OrganizationSerializer,
               status: 200
      end

      def update
        org = Organization.find(params[:id])
        org.update!(params)
        render json: org, status: 200
      end

      def create
        org = Organization.new(params)
        org.user_id = current_api_user.id
        if org.save
          render json: org, status: 201, location: [:api, org]
        else
          render json: @blog_post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        org = Organization.find(params[:id])
        org.destroy
        head 204
      end

      def locations
        locations = Organization.find(params[:organization_id])
                                .locations
                                .includes(:address, :phones)
                                .page(params[:page])
                                .per(params[:per_page])
        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
      end
    end
  end
end
