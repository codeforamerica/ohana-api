module Api
  module V1
    class StatusController < ApplicationController
      def check_status
        response_hash = {}
        response_hash[:dependencies] = %w(Mandrill Postgres)
        response_hash[:status] = everything_ok? ? 'ok' : 'NOT OK'
        response_hash[:updated] = Time.now.to_i

        render json: response_hash
      end

      private

      def everything_ok?
        # Check that database contains items and that search returns results
        database_okay? && search_okay?
      end

      def database_okay?
        Location.first.present?
      end

      def search_okay?
        Location.text_search(keyword: 'food').page(1).per(1).present?
      end
    end
  end
end
