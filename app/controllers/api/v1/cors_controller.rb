module Api
  module V1
    class CorsController < ApplicationController
      def render_204
        head 204
      end
    end
  end
end
