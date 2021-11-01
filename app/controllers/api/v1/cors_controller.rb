module Api
  module V1
    class CorsController < ApplicationController
      def render_204
        head :no_content
      end
    end
  end
end
