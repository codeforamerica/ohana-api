module Api
  module V1
    class CorsController < ApplicationController

      skip_before_action :verify_authenticity_token

      def render_204
        head 204
      end
    end
  end
end
