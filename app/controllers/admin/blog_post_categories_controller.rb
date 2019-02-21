class Admin
  class BlogPostCategoriesController < ApplicationController
    before_action :authenticate_admin!

    def update
      Tag.where(id: params[:toDelete]).delete_all
      Tag.create!(
        params[:newers].reject(&:blank?).map{ |category| { name: category } }
      )
      render json: {}, status: :ok
    end
  end
end
