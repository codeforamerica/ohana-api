module Api
  module UrlHelpers
    def api_endpoint(options = {})
      subdomain = options[:subdomain] || SETTINGS[:api_subdomain]
      subdomain += '.' unless subdomain.blank?
      api_path = SETTINGS[:api_path]
      path = "#{api_path}#{options[:path]}"
      domain = SETTINGS[:base_domain]
      domain += '/' unless api_path.blank?

      "http://#{subdomain}#{domain}#{path}"
    end

    def docs_endpoint(options = {})
      subdomain = options[:subdomain] || SETTINGS[:docs_subdomain]
      subdomain += '.' unless subdomain.blank?
      domain = SETTINGS[:base_domain]
      path = options[:path] || '/docs'

      "http://#{subdomain}#{domain}#{path}"
    end
  end
end
