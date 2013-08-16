module Api
  module V1
    class OrganizationsController < ApiController

      #These filters provide pagination info via HTTP Link headers
      #thanks to the 'api-pagination' gem
      after_filter only: [:index] { paginate(:orgs) }
      after_filter only: [:search] { paginate(:results) }
      after_filter only: [:nearby] { paginate(:nearby) }

      caches :index, :show, :search, :caches_for => 5.minutes

      def index
        @orgs = Organization.page(params[:page]).per(30)
        expose @orgs
      end

      def show
        expose Organization.find(params[:id])
      end

      def nearby
        org = Organization.find(params[:id])
        @nearby = Organization.nearby(org, params)
        expose @nearby
      end

      def search
        @results = Organization.search(params)
        expose @results
      end
    end
  end
end