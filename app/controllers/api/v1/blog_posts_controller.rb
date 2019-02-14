module Api
  module V1
    class BlogPostsController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      skip_before_action :verify_authenticity_token

      before_action :set_blog_post, only: %i[update destroy]
      after_action :set_cache_control, only: :index

      def index
        blog_posts = filter_posts

        generate_pagination_headers(blog_posts)
        render json: blog_posts,
               each_serializer: BlogPostSerializer,
               status: 200
      end

      def create
        @blog_post = BlogPost.new(blog_post_params)
        @blog_post.category_list.add(blog_post_params[:category])
        if @blog_post.save
          render json: @blog_post,
                 serializer: BlogPostSerializer,
                 status: 200
        else
          render json: @blog_post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @blog_post.update(blog_post_params)
          render json: @blog_post,
                 serializer: BlogPostSerializer,
                 status: 200
        else
          render json: @blog_post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        if @blog_post.destroy
          render json: {}, status: :ok
        else
          render json: @blog_post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
     end

      private

      def blog_post_params
        params.require(:blog_post).permit(
          :title,
          :body,
          :posted_at,
          :category,
          :admin_id,
          :is_published,
          blog_post_attachments_attributes: [
            :id,
            :file_type,
            :file_url,
            :file_legend,
            :order,
            :_destroy
          ]
        )
      end

      def set_blog_post
        @blog_post = BlogPost.find(params[:id])
      end

      def filter_posts
        blog_post = if params.present? && params.dig(:filter, :category).present?
                      BlogPost.tagged_with(params[:filter][:category])
                    elsif params.present? && params.dig(:filter, :draft).present?
                      BlogPost.where(is_published: false)
                    else
                      BlogPost.all
                    end
        blog_post.page(params[:page])
                 .per(params[:per_page])
                 .order('posted_at ASC')
      end
    end
  end
end
