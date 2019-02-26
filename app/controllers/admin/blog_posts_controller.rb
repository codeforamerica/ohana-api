class Admin
  class BlogPostsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @blog_posts = Kaminari.paginate_array(policy_scope(filter_blog_posts))
      @blog_posts = @blog_posts.page(params[:page])
                               .per(params[:per_page])
    end

    def show
      @blog_post = BlogPost.find(params[:id])
    end

    def edit
      @blog_post = BlogPost.find(params[:id])

      authorize @blog_post
    end

    def update
      @blog_post = BlogPost.find(params[:id])
      @blog_post.category_list = params[:blog_post][:category_list].reject(&:blank?)
      if @blog_post.update(params[:blog_post])
        redirect_to admin_blog_posts_path,
                    notice: 'Blog Post was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      blog_post = BlogPost.find(params[:id])
      blog_post.destroy
      redirect_to admin_blog_posts_path
    end

    private

    def filter_blog_posts
      blog_posts = BlogPost.all
      if params[:filter] == 'front page' || params[:filter] == 'featured'
        blog_posts = blog_posts.tagged_with(params[:filter])
      end

      blog_posts
    end
  end
end
