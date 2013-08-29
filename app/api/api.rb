module API
  class Root < Grape::API
    prefix 'api'
    format :json
    version 'v1', using: :header, vendor: 'ohanapi', strict: true

    rescue_from Mongoid::Errors::DocumentNotFound do
      rack_response({
        "error" => "Not Found",
        "message" => "The requested resource could not be found."
      }.to_json, 404)
    end

    mount Ohana::API
    Grape::Endpoint.send :include, LinkHeader
    add_swagger_documentation markdown: true, hide_documentation_path: true,
      hide_format: true, api_version: 'v1'
  end
end