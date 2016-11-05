module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        categories = Category.all
        render json: categories, status: 200
      end

      def children
        children = Category.find_by(taxonomy_id: params[:taxonomy_id]).children
        render json: children, status: 200
      end
    end
  end
end
