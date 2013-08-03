module Api
  module V1
    class OrganizationsController < ApiController

      #These filters provide pagination info via HTTP Link headers
      #thanks to the 'api-pagination' gem
      after_filter only: [:index] { paginate(:orgs) }

      caches :index, :show, :caches_for => 5.minutes

      def index
        @orgs = Organization.page(params[:page]).per(30)
        expose @orgs
      end

      def show
        expose Organization.find(params[:id])
      end
    end
  end
end