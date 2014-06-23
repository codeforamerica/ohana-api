module Api
  module UrlHelpers
    def api_endpoint(options = {})
      subdomain = options[:subdomain] || ENV['API_SUBDOMAIN']
      subdomain += '.' unless subdomain.blank?
      api_path = ENV['API_PATH']
      path = "#{api_path}#{options[:path]}"
      domain = ENV['BASE_DOMAIN']
      domain += '/' unless api_path.blank?

      "http://#{subdomain}#{domain}#{path}"
    end

    def docs_endpoint(options = {})
      subdomain = options[:subdomain] || ENV['DEV_SUBDOMAIN']
      subdomain += '.' unless subdomain.blank?
      domain = ENV['BASE_DOMAIN']
      path = options[:path] || '/docs'

      "http://#{subdomain}#{domain}#{path}"
    end
  end
end
