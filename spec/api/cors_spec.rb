require 'spec_helper'

describe 'CORS REQUESTS' do
  context 'when ORIGIN is specified' do
    before :each do
      create(:organization)
      get(
        'api/organizations',
        {},
        'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json',
        'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => 'Rspec'
      )
    end

    it 'gets version 1' do
      expect(response).to be_success
    end

    it 'retrieves a content-type of json' do
      expect(headers['Content-Type']).to include 'application/json'
    end

    it 'includes CORS headers when ORIGIN is specified' do
      expect(headers.keys).to include('Access-Control-Allow-Origin')
      expect(headers['Access-Control-Allow-Origin']).to eq('http://ohanapi.org')
    end

    it 'allows GET, POST, & PUT HTTP methods thru CORS' do
      allowed_http_methods = headers['Access-Control-Allow-Methods']
      %w(GET POST PUT).each do |method|
        expect(allowed_http_methods).to include(method)
      end
    end
  end

  context 'when ORIGIN is not specified' do
    it 'does not include CORS headers when ORIGIN is not specified' do
      get 'api/organizations', {}, 'HTTP_USER_AGENT' => 'Rspec'
      expect(response.status).to eq 200
      expect(headers.keys).not_to include('Access-Control-Allow-Origin')
      expect(headers['Access-Control-Allow-Origin']).to be_nil
    end
  end
end
