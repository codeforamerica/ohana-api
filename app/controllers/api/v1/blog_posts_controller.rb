module Api
  module V1
    class BlogPostsController < Api::V1::BaseController
      include PaginationHeaders
      include Cacheable
      include ErrorSerializer

      before_action :authenticate_api_user!, except: [:index, :show, :categories]
      before_action :set_blog_post, only: %i[show update destroy]
      after_action :set_cache_control, only: :index

      def index
        blog_posts = filter_posts

        generate_pagination_headers(blog_posts)
        render json: blog_posts,
               each_serializer: BlogPostSerializer,
               status: 200
      end

      def show
        render json: @blog_post,
               serializer: BlogPostSerializer,
               status: 200
      end

      def create
        @blog_post = BlogPost.new(blog_post_params)
        @blog_post.user_id = current_api_user.id
        @blog_post.posted_at = DateTime.now
        @blog_post.category_list.add(blog_post_params[:category])
        if @blog_post.save
          render json: @blog_post,
                 serializer: BlogPostSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(@blog_post.errors),
                 status: :unprocessable_entity
        end
      end

      def update
        if @blog_post.update(blog_post_params)
          render json: @blog_post,
                 serializer: BlogPostSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(@blog_post.errors),
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @blog_post.destroy
          render json: {}, status: :ok
        else
          render json: ErrorSerializer.serialize(@blog_post.errors),
                 status: :unprocessable_entity
        end
      end

      def categories
        categories = Tag.all
        render json: categories,
               each_serializer: TagSerializer,
               status: 200
      end

      private

      def blog_post_params
        params.require(:blog_post).permit(
          :title,
          :body,
          :posted_at,
          :category,

          :is_published,
          :organization_id,
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
        blog_post = BlogPost.all
        if params[:filter].present?
          blog_post = blog_post.tagged_with(params[:filter][:category]) if params[:filter][:category].present?
          blog_post = blog_post.where(is_published: false) if params[:filter][:draft].present?
          blog_post = blog_post.where(organization_id: params[:filter][:organization_id]) if params[:filter][:organization_id].present?
        end
        blog_post.page(params[:page])
                 .per(params[:per_page])
                 .order('posted_at ASC')
      end
    end
  end
end
