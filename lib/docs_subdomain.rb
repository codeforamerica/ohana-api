class DocsSubdomain
  def self.matches?(request)
    if SETTINGS[:docs_subdomain].present?
      request.subdomain == SETTINGS[:docs_subdomain]
    else
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end
