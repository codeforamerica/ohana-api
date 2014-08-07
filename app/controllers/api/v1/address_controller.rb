module Api
  module V1
    class AddressController < ApplicationController
      include TokenValidator
      include CustomErrors

      def update
        address = Address.find(params[:id])
        address.update!(params)
        render json: address, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        address = location.create_address!(params) unless location.address.present?
        render json: address, status: 201
      end

      def destroy
        location = Location.find(params[:location_id])
        address_id = location.address.id
        location.address_attributes = { id: address_id, _destroy: '1' }
        location.save!
        head 204
      end
    end
  end
end
