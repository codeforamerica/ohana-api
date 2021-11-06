module Api
  module V1
    class ContactPhonesController < ApplicationController
      include TokenValidator
      include CustomErrors

      def update
        phone = Phone.find(params[:id])
        phone.update!(phone_params)
        render json: phone, status: :ok
      end

      def create
        contact = Contact.find(params[:contact_id])
        phone = contact.phones.create!(phone_params)
        render json: phone, status: :created
      end

      def destroy
        phone = Phone.find(params[:id])
        phone.destroy
        head :no_content
      end

      private

      def phone_params
        params.permit(
          :country_prefix, :department, :extension, :number, :number_type, :vanity_number
        )
      end
    end
  end
end
