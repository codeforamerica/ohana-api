class ApiSubdomain
  def self.matches?(request)
    if ENV['API_SUBDOMAIN'].present?
      request.subdomain == ENV['API_SUBDOMAIN']
    else
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end
