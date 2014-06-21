class ApiSubdomain
  def self.matches?(request)
    if SETTINGS[:api_subdomain].present?
      request.subdomain == SETTINGS[:api_subdomain]
    else
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end
