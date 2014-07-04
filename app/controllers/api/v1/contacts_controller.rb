module Api
  module V1
    class ContactsController < ApplicationController
      include TokenValidator
      include CustomErrors

      def index
        location = Location.find(params[:location_id])
        contacts = location.contacts
        render json: contacts, status: 200
      end

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
