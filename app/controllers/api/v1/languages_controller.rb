module Api
  module V1
    class LanguagesController < ApiController

      caches :index, :caches_for => 5.minutes

      def index
        expose Language.all
      end
    end
  end
end