class AssetHosts
  def call(_source, request = nil)
    return if request.nil?
    @request = request
    return asset_host_with_port if host_same_as_asset_host? || unauthorized_host?
    "#{subdomain}#{asset_host_with_port}"
  end

  private

  attr_reader :request

  def asset_host_with_port
    "#{asset_host}#{port}"
  end

  def asset_host
    @asset_host ||= Figaro.env.asset_host
  end

  def port
    ":#{request_port}" if request_port
  end

  def request_port
    @request_port ||= request.port
  end

  def host_same_as_asset_host?
    request.host == asset_host
  end

  def unauthorized_host?
    !request.host.end_with?(asset_host)
  end

  def subdomain
    request.host.split(asset_host)[0]
  end
end
