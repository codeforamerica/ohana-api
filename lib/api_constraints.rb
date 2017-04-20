class ApiConstraints
  def initialize(options)
    @version = options[:version]
  end

  def matches?(request)
    @request ||= request
    versioned_accept_header? || @version == 1
  end

  private

  def versioned_accept_header?
    accept = @request.headers['Accept']
    return false unless accept.present?
    mime_type, version = accept.gsub(/\s/, '').split(';')
    mime_type.match(/vnd\.ohanapi\+json/) && version == "version=#{@version}"
  end
end
