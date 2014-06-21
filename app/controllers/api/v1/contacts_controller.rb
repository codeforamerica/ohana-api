module Api
  module V1
    class ContactsController < ApplicationController
      include TokenValidator

      before_action :validate_token!, only: [:update, :destroy, :create]

      def update
        contact = Contact.find(params[:id])
        contact.update!(params)
        render json: contact, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        contact = location.contacts.create!(params)
        render json: contact, status: 201
      end

      def destroy
        contact = Contact.find(params[:id])
        contact.destroy
        head 204
      end
    end
  end
end
