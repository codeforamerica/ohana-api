module Api
  module V1
    class AddressController < Api::V1::BaseController
      include CustomErrors

      before_action :authenticate_api_user!

      def update
        location.update!(address_attributes: params)
        render json: location.address, status: 200
      end

      def create
        address = location.create_address!(params) if location.address.blank?
        render json: address, status: 201
      end

      def destroy
        address_id = location.address.id
        location.address_attributes = { id: address_id, _destroy: '1' }
        location.save!
        head 204
      end

      private

      def location
        @location ||= Location.find(params[:location_id])
      end
    end
  end
end
