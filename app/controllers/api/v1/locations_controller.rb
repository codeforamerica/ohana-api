module Api
  module V1
    class LocationsController < Api::V1::BaseController
      include PaginationHeaders
      include Cacheable
      include CustomErrors
      include ErrorSerializer

      before_action :authenticate_api_user!, except: [:index, :show]
      after_action :set_cache_control, only: %i[index show]

      def index
        locations = Location.includes(:organization, :address, :phones, :services).
                    page(params[:page]).per(params[:per_page]).
                    order('created_at DESC')

        render json: locations, each_serializer: LocationsSerializer, status: 200
        generate_pagination_headers(locations)
      end

      def show
        location = Location.includes(
          contacts: :phones,
          services: %i[categories contacts phones regular_schedules
                       holiday_schedules]
        ).find(params[:id])
        render json: location, status: 200 if stale?(location, public: true)
      end

      def update
        location = Location.find(params[:id])
        if location.update(location_params)
          render json: location,
                 serializer: LocationSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(location.errors),
                 status: :unprocessable_entity
        end
      end

      def create
        org = Organization.where(id: params[:organization_id])
                          .where(user_id: current_api_user.id)
                          .first
        unless org.present?
          render json: [], status: 403
          return
        end
        location = org.locations.build(params)
        if org.save
          render json: location, status: 201, location: [:api, location]
        else
          render json: ErrorSerializer.serialize(location.errors),
                 status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotUnique => error
        render status: 422,
               json: { model: 'Location', errors: 'Location name already exists' }
      end

      def destroy
        location = Location.find(params[:id])
        location.destroy
        head 204
      end

      private

      def location_params
        params.permit(
          :active,
          :admin_emails,
          :alternate_name,
          :description,
          :email,
          :latitude,
          :longitude,
          :name,
          :short_desc,
          :transportation,
          :website,
          :virtual,
          accessibility: [],
          languages: [],
          regular_schedules_attributes: [
            :id,
            :opens_at,
            :closes_at,
            :weekday
          ],
          holiday_schedules_attributes: [
            :id,
            :closed,
            :start_date,
            :end_date,
            :opens_at,
            :closes_at
          ]
        )
      end
    end
  end
end
