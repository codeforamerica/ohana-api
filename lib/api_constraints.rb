class ApiConstraints
  def initialize(options)
    @version = options[:version]
  end

  def matches?(request)
    versioned_accept_header?(request) || @version == 1
  end

  private

  def versioned_accept_header?(request)
    accept = request.headers['Accept']
    return false if accept.blank?
    mime_type, version = accept.gsub(/\s/, '').split(';')
    mime_type.match(/vnd\.ohanapi\+json/) && version == "version=#{@version}"
  end
end
