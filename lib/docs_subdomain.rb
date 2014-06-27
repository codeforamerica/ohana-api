class DocsSubdomain
  def self.matches?(request)
    if ENV['DEV_SUBDOMAIN'].present?
      request.subdomain == ENV['DEV_SUBDOMAIN']
    else
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end
