module Api
  module V1
    class ContactsController < Api::V1::BaseController
      include CustomErrors
      include ErrorSerializer

      before_action :authenticate_api_user!, except: [:index]

      def index
        location = Location.find(params[:location_id])
        contacts = location.contacts
        render json: contacts, status: 200
      end

      def update
        contact = Contact.find(params[:id])
        if contact.update(contact_params)
          render json: contact,
                 serializer: ContactSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(contact.errors),
                 status: :unprocessable_entity
        end
      end

      def create
        location = Location.find(params[:location_id])
        contact = location.contacts.build(params)
        if location.save
          render json: contact, status: 201
        else
          render json: ErrorSerializer.serialize(contact.errors),
                 status: :unprocessable_entity
        end
      end

      def destroy
        contact = Contact.find(params[:id])
        contact.destroy
        head 204
      end

      def contact_params
        params.permit(
          :department,
          :email,
          :name,
          :title,
          phones_attributes: [
            :id,
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
