module Api
    module V1
      class BlogPostImagesController < Api::V1::BaseController
        include ErrorSerializer

        def create
            @bp_image = BlogPostImage.new(blog_post_image_params)
            if @bp_image.save
              render json: {url:@bp_image.image.url}, status: 200
            else
              render json: ErrorSerializer.serialize(@bp_image.errors),
                     status: :unprocessable_entity
            end
        end

        private

        def blog_post_image_params
          params.permit(
            :local_identifier,
            :image,
            :organization_id
          )
        end
      end
    end
  end
