module Api
  module V1
    class RootController < ApplicationController
      def index
        render  status: 200,
                json: config_for(:root_endpoints, :urls, host: root_url)

      end
    end
  end
end
