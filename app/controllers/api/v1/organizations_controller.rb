module Api
  module V1
    class OrganizationsController < ApplicationController      
      respond_to :json

      def index
        respond_with Organization.all
      end

      def show
        respond_with Organization.find(params[:id])
      end
    end
  end
end