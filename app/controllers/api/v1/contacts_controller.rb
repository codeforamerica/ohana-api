module Api
  module V1
    class ContactsController < ApplicationController
      include TokenValidator
      include CustomErrors

      def index
        location = Location.find(params[:location_id])
        contacts = location.contacts
        render json: contacts, status: :ok
      end

      def update
        contact = Contact.find(params[:id])
        contact.update!(contact_params)
        render json: contact, status: :ok
      end

      def create
        location = Location.find(params[:location_id])
        contact = location.contacts.create!(contact_params)
        render json: contact, status: :created
      end

      def destroy
        contact = Contact.find(params[:id])
        contact.destroy
        head 204
      end

      private

      def contact_params
        params.require(:contact).permit(:department, :email, :name, :title)
      end
    end
  end
end
