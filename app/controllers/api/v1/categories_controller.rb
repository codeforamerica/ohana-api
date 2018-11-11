module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        categories = Category.all
        render json: categories, status: :ok
      end

      def children
        children = Category.find_by(taxonomy_id: params[:taxonomy_id]).children
        render json: children, status: :ok
      end
    end
  end
end
