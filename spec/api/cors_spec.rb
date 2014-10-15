require 'rails_helper'

describe 'CORS Preflight Request via OPTIONS HTTP method' do
  context 'when ORIGIN is specified and resource is allowed' do
    before :each do
      options api_organizations_url(subdomain: ENV['API_SUBDOMAIN']), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'Content-Type',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'
    end

    it 'returns a 200 status with no content' do
      expect(response).to have_http_status(200)
      expect(response.body).to eq ''
    end

    it 'sets Access-Control-Allow-Origin header to the Origin in the request' do
      expect(headers['Access-Control-Allow-Origin']).
        to eq('http://cors.example.com')
    end

    it 'sets Access-Control-Allow-Methods to the whitelisted methods' do
      allowed_http_methods = headers['Access-Control-Allow-Methods']
      expect(allowed_http_methods).
        to eq(%w(GET PUT PATCH POST DELETE).join(', '))
    end

    it 'returns the Access-Control-Max-Age header' do
      expect(headers['Access-Control-Max-Age']).to eq('1728000')
    end

    it 'returns the Access-Control-Allow-Credentials header' do
      expect(headers['Access-Control-Allow-Credentials']).to eq('true')
    end

    it 'returns the Access-Control-Allow-Headers header' do
      expect(headers['Access-Control-Allow-Headers']).to eq('Content-Type')
    end

    it 'only exposes the Etag, Last-Modified, Link and X-Total-Count headers' do
      expect(headers['Access-Control-Expose-Headers']).
        to eq('Etag, Last-Modified, Link, X-Total-Count')
    end

    it 'allows access to the locations endpoint' do
      options api_locations_url(subdomain: ENV['API_SUBDOMAIN']), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'

      expect(headers['Access-Control-Allow-Origin']).
        to eq('http://cors.example.com')
    end

    it 'allows access to a specific location' do
      options api_location_url(1, subdomain: ENV['API_SUBDOMAIN']), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'

      expect(headers['Access-Control-Allow-Origin']).
        to eq('http://cors.example.com')
    end

    it 'allows access to a specific organization' do
      options api_organization_url(1, subdomain: ENV['API_SUBDOMAIN']), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'

      expect(headers['Access-Control-Allow-Origin']).
        to eq('http://cors.example.com')
    end

    it 'allows access to the search endpoint' do
      options api_search_index_url(keyword: 'food', subdomain: ENV['API_SUBDOMAIN']),
              {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'

      expect(headers['Access-Control-Allow-Origin']).
        to eq('http://cors.example.com')
    end

    it 'does not allow access to non-whitelisted endpoints' do
      options url_for('api/foo'), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'

      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
    end
  end

  context 'when request is not a valid preflight request' do
    before(:each) do
      options api_organizations_url(subdomain: ENV['API_SUBDOMAIN']), {},
              'HTTP_ORIGIN' => 'http://cors.example.com'
    end

    it 'returns a 204 status with no content' do
      expect(response).to have_http_status(204)
    end

    # Disabled temporarily until this bug is fixed in rack-cors:
    # https://github.com/cyu/rack-cors/issues/58
    xit 'does not include CORS headers' do
      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
    end
  end
end

describe 'CORS REQUESTS - POST and GET' do
  context 'when ORIGIN is specified' do
    before :each do
      post api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
           { name: 'foo', description: 'test' },
           'HTTP_ACCEPT' => 'application/vnd.ohanapi+json; version=1',
           'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => 'Rspec'
    end

    it 'returns a 201 status' do
      expect(response).to have_http_status(201)
    end

    it 'sets Access-Control-Allow-Origin header to the Origin in the request' do
      expect(headers['Access-Control-Allow-Origin']).to eq('http://ohanapi.org')
    end

    it 'sets Access-Control-Allow-Methods to the whitelisted methods' do
      allowed_http_methods = headers['Access-Control-Allow-Methods']
      expect(allowed_http_methods).
        to eq(%w(GET PUT PATCH POST DELETE).join(', '))
    end

    it 'returns the Access-Control-Max-Age header' do
      expect(headers['Access-Control-Max-Age']).to eq('1728000')
    end

    it 'returns the Access-Control-Allow-Credentials header' do
      expect(headers['Access-Control-Allow-Credentials']).to eq('true')
    end

    it 'only exposes the Etag, Last-Modified, Link and X-Total-Count headers' do
      expect(headers['Access-Control-Expose-Headers']).
        to eq('Etag, Last-Modified, Link, X-Total-Count')
    end

    it "doesn't allow updating a location without a valid token" do
      post api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
           { name: 'foo', description: 'test' },
           'HTTP_ACCEPT' => 'application/vnd.ohanapi+json; version=1',
           'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => 'Rspec',
           'HTTP_X_API_TOKEN' => 'invalid_token'

      expect(response.status).to eq(401)
      expect(json['message']).
        to eq('This action requires a valid X-API-Token header.')
    end
  end

  context 'when ORIGIN is not specified' do
    it 'does not include CORS headers when ORIGIN is not specified' do
      post api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
           { name: 'foo', description: 'test' },
           'HTTP_ACCEPT' => 'application/vnd.ohanapi+json; version=1',
           'HTTP_USER_AGENT' => 'Rspec'
      expect(response.status).to eq 201
      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
    end
  end

  context 'when ORIGIN is specified and path is invalid' do
    before :each do
      get api_location_url(123, subdomain: ENV['API_SUBDOMAIN']),
          {}, 'HTTP_ORIGIN' => 'http://ohanapi.org'
    end

    it 'returns a 404 status' do
      expect(response).to have_http_status(404)
    end

    it 'sets Access-Control-Allow-Origin header to the Origin in the request' do
      expect(headers['Access-Control-Allow-Origin']).to eq('http://ohanapi.org')
    end
  end
end
