class SubdomainConstraints
  def initialize(options)
    @subdomain = options[:subdomain]
  end

  def matches?(request)
    if @subdomain.present?
      request.subdomain == @subdomain
    else
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end
