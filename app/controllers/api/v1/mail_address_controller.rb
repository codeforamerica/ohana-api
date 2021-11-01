module Api
  module V1
    class MailAddressController < ApplicationController
      include TokenValidator
      include CustomErrors

      def update
        mail_address = MailAddress.find(params[:id])
        mail_address.update!(mail_address_params)
        render json: mail_address, status: :ok
      end

      def create
        location = Location.find(params[:location_id])
        if location.mail_address.blank?
          mail_address = location.create_mail_address!(mail_address_params)
        end
        render json: mail_address, status: :created
      end

      def destroy
        location = Location.find(params[:location_id])
        mail_address_id = location.mail_address.id
        location.mail_address_attributes = { id: mail_address_id, _destroy: '1' }
        location.save!
        head :no_content
      end

      private

      def mail_address_params
        params.require(:mail_address).permit(
          :attention, :address_1, :address_2, :city, :state_province, :postal_code, :country
        )
      end
    end
  end
end
