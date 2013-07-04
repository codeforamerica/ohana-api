module Api
  module V1
    class OrganizationsController < ApiController

      #These filters provide pagination info via HTTP Link headers
      #thanks to the 'api-pagination' gem
      after_filter only: [:index] { paginate(:orgs) }
      after_filter only: [:search] { paginate(:results) }

      caches :index, :show, :search, :caches_for => 5.minutes

      def index
        @orgs = Organization.page(params[:page]).per(30)
        expose @orgs
      end

      def show
        expose Organization.find(params[:id])
      end

      def search
        @results = org_search(params).all.page(params[:page]).per(30)
        begin
          expose @results
        rescue Moped::Errors::QueryFailure
          error! :bad_request,
                 :metadata => {
                   :specific_reason => "Invalid ZIP code or address"
                 }
        end
      end
    end
  end
end