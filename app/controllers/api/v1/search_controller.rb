module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: :index

      def index
        searchResults = PgSearch.multisearch(params[:text])
        render json: searchResults, status: 200
      end
    end
  end
end
