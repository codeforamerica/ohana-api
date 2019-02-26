class Admin
  class BlogPostCategoriesController < ApplicationController
    before_action :authenticate_admin!

    PERSISTED_CATEGORIES = %w[1 2].freeze

    def update
      if params[:toDelete].present?
        Tag.where(id: params[:toDelete] - PERSISTED_CATEGORIES).delete_all
      end
      if params[:newers].present?
        params[:newers].reject(&:blank?).each do |category|
          Tag.find_or_create_by!(name: category)
        end
      end
      render json: {}, status: :ok
    end
  end
end
