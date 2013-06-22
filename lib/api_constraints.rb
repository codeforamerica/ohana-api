# based on https://gist.github.com/jpemberthy/2713548
# and http://railscasts.com/episodes/350-rest-api-versioning
# Usage by client making an API request:
# curl "http://url/to/api" -H "Accept: application/vnd.ohanapi+json; version=1"

class ApiConstraints
  def initialize(version)
    @version = version
  end

  def matches?(request)
    versioned_accept_header?(request) || @version == 1
  end

  private

  def versioned_accept_header?(request)
    accept = request.headers['Accept']

    if accept
      mime_type, version = accept.gsub(/\s/, "").split(";")
      mime_type.match(/vnd\.ohanapi\+json/) && version == "version=#{@version}"
    end
  end
end