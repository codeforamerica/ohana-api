module Api
  module V1
    class MailAddressController < Api::V1::BaseController
      include CustomErrors
      include ErrorSerializer

      before_action :authenticate_api_user!

      def update
        mail_address = MailAddress.find(params[:id])
        mail_address.update!(params)
        render json: mail_address, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        if location.mail_address.blank?
          mail_address = location.create_mail_address!(params)
        end
        render json: mail_address, status: 201
      end

      def destroy
        location = Location.find(params[:location_id])
        mail_address_id = location.mail_address.id
        location.mail_address_attributes = { id: mail_address_id, _destroy: '1' }
        location.save!
        head 204
      end
    end
  end
end
