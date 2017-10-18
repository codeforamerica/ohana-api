module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: :index

      def index
        search_results = PgSearch.multisearch(params[:text])
        render json: search_results, status: 200
      end
    end
  end
end
