module Api
  module V1
    class OrganizationsController < Api::V1::BaseController
      include PaginationHeaders
      include CustomErrors
      include ErrorSerializer

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
                                    .where(is_published: true)
        generate_pagination_headers(organizations)
        render json: organizations,
               each_serializer: OrganizationSerializer,
               status: 200
      end

      def show
        org = Organization.find(params[:id])
        render json: org,
               serializer: OrganizationSerializer,
               status: 200
      end

      def update
        org = Organization.where(id: params[:id])
                          .where(user_id: current_api_user.id)
        if org.empty?
          render json: [], status: 403
          return
        end
        if org.any? && org.first.update(organization_params)
          render json: org,
                 each_serializer: OrganizationSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(org.first.errors),
                 status: :unprocessable_entity
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

      private

      def organization_params
        params.require(:organization).permit(
          :accreditations,
          :alternate_name,
          :date_incorporated,
          :description,
          :email,
          :funding_sources,
          :licenses,
          :name,
          :website,
          :twitter,
          :facebook,
          :linkedin,
          :logo_url,
          :is_published,
          :legal_status,
          :tax_id,
          :tax_status,
          :rank,
          phones_attributes: [
            :id,
            :country_prefix,
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
