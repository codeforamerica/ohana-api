module Api
  module V1
    class OrganizationsController < RocketPants::Base

      caches :index, :show, :caches_for => 5.minutes

      def index
        expose Organization.paginate(:page => params[:page], :per_page => 30)
      end

      def show
        expose Organization.find(params[:id])
      end
    end
  end
end