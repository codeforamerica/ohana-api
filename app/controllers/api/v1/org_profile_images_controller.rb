module Api
    module V1
      class OrgProfileImagesController < Api::V1::BaseController
        include ErrorSerializer

        def create
          org_id = org_profile_image_params[:organization_id]
          image = org_profile_image_params[:image]
          @profile_image = OrgProfileImage.find_or_initialize_by(organization_id:org_id)
          @profile_image.image = image
          if @profile_image.save
            render json: {url:@profile_image.image.url}, status: 200
          else
            render json: ErrorSerializer.serialize(@profile_image.errors),
                    status: :unprocessable_entity
          end
        end

        private

        def org_profile_image_params
          params.permit(
            :local_identifier,
            :image,
            :organization_id
          )
        end
      end
    end
  end
