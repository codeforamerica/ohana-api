require 'rails_helper'

describe 'CORS Preflight Request via OPTIONS HTTP method' do
  xcontext 'when ORIGIN is specified and resource is allowed' do
    before :each do
      create(:organization)
      options api_endpoint(path: '/organizations'), {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'Origin, Accept, Content-Type',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
              'REQUEST_METHOD' => 'OPTIONS'
    end

    it 'returns a 204 status with no content' do
      expect(response).to have_http_status(204)
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

    it 'returns an empty Access-Control-Expose-Headers header' do
      expect(headers['Access-Control-Expose-Headers']).to eq('')
    end
  end

  context 'when ORIGIN is not specified' do
    before(:each) do
      options api_endpoint(path: '/organizations'), {}
    end

    it 'returns a 204 status with no content' do
      expect(response).to have_http_status(204)
    end

    it 'does not include CORS headers when ORIGIN is not specified' do
      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
    end
  end
end

describe 'CORS REQUESTS - POST and GET' do
  context 'when ORIGIN is specified' do
    before :each do
      loc = create(:location)
      post api_endpoint(path: "/locations/#{loc.id}/contacts"),
           { name: 'foo', title: 'cfo' },
           'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
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

    it 'returns an empty Access-Control-Expose-Headers header' do
      expect(headers['Access-Control-Expose-Headers']).to eq('')
    end
  end

  context 'when ORIGIN is not specified' do
    it 'does not include CORS headers when ORIGIN is not specified' do
      loc = create(:location)
      post api_endpoint(path: "/locations/#{loc.id}/contacts"),
           { name: 'foo', title: 'cfo' },
           'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
           'HTTP_ACCEPT' => 'application/vnd.ohanapi+json; version=1',
           'HTTP_USER_AGENT' => 'Rspec'
      expect(response.status).to eq 201
      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
    end
  end

  context 'when ORIGIN is specified and path is invalid' do
    before :each do
      get api_endpoint(path: '/locations/123'), {}, 'HTTP_ORIGIN' => 'http://ohanapi.org'
    end

    it 'returns a 404 status' do
      expect(response).to have_http_status(404)
    end

    it 'sets Access-Control-Allow-Origin header to the Origin in the request' do
      expect(headers['Access-Control-Allow-Origin']).to eq('http://ohanapi.org')
    end
  end
end
