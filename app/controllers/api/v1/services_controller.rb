module Api
  module V1
    class ServicesController < ApplicationController
      include TokenValidator

      before_action :validate_token!, only: [:update, :destroy, :create, :update_categories]

      def update
        service = Service.find(params[:id])
        service.update!(params)
        render json: service, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        service = location.services.create!(params)
        render json: service, status: 201
      end

      def destroy
        service = Service.find(params[:id])
        service.destroy
        head 204
      end

      def update_categories
        s = Service.find(params[:services_id])

        # Create an array of category ids from the category slugs
        # that were passed in. The slugs are 'URL friendly' versions
        # of the Open Eligibility (http://openeligibility.org) category
        # names.
        # For example, 'Prevent & Treat' becomes 'prevent-and-treat'.
        # If you want to see all 327 slugs, run this command from the
        # Rails console:
        # Category.all.map(&:slug)
        cat_ids = []
        params[:category_slugs].each do |cat_slug|
          cat = Category.find(cat_slug)
          cat_ids.push(cat.id)
        end

        # Set the service's category_ids to this new array of ids
        s.category_ids = cat_ids
        s.save

        render json: s, status: 200
      end
    end
  end
end
