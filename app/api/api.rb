require "garner/mixins/rack"

module API
  class Root < Grape::API
    prefix 'api'
    format :json
    version 'v1', using: :header, vendor: 'ohanapi'

    helpers do

      Garner::Mixins::Rack

      Garner.configure do |config|
        config.mongoid_identity_fields = [:_id]
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless valid_api_token?
      end

      # @param  [Rack::Request] request
      # @return [Boolean]
      def valid_api_token?
        token = env["HTTP_X_API_TOKEN"].to_s
        token.present? && User.where('api_applications.api_token' => token).exists?
      end

    end

    rescue_from Mongoid::Errors::DocumentNotFound do
      rack_response({
        "error" => "Not Found",
        "message" => "The requested resource could not be found."
      }.to_json, 404)
    end

    rescue_from Mongoid::Errors::Validations do |e|
      rack_response({
        "message" => e.message
      }.to_json, 400)
    end

    mount Ohana::API
    Grape::Endpoint.send :include, LinkHeader
    add_swagger_documentation markdown: true, hide_documentation_path: true,
      hide_format: true, api_version: 'v1'
  end
end