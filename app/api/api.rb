#require "garner/mixins/rack"
require "active_support/cache/dalli_store"

module API
  class Root < Grape::API
    prefix 'api'
    format :json
    # If you want to disallow an empty Accept header,
    # add strict: true below. If you want to return a 404
    # instead of a 406 when an invalid Accept header is supplied,
    # remove cascade: false. See the grape README for more details:
    # https://github.com/intridea/grape#header
    version 'v1', using: :header, vendor: 'ohanapi', cascade: false

    helpers do

      #Garner::Mixins::Rack

      # Garner.configure do |config|
      #   config.cache = ActiveSupport::Cache::DalliStore.new(ENV["MEMCACHIER_SERVERS"], { :compress => true })
      # end

      def authenticate!
        error!('401 Unauthorized', 401) unless valid_api_token?
      end

      # @param  [Rack::Request] request
      # @return [Boolean]
      def valid_api_token?
        token = env["HTTP_X_API_TOKEN"].to_s
        token.present? && token == ENV["ADMIN_APP_TOKEN"]
      end
    end

    rescue_from ActiveRecord::RecordNotFound do
      rack_response({
        "error" => "Not Found",
        "message" => "The requested resource could not be found."
      }.to_json, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      if e.record.errors.first.first == :kind
        message = "Please enter a valid value for Kind"
      elsif e.record.errors.first.first == :accessibility
        message = "Please enter a valid value for Accessibility"
      else
        message = e.message
      end

      rack_response({
        "message" => message
      }.to_json, 400)
    end

    mount Ohana::API
    Grape::Endpoint.send :include, LinkHeader
    add_swagger_documentation markdown: true, hide_documentation_path: true,
      hide_format: true, api_version: 'v1'
  end
end