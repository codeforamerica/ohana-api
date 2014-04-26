require 'spec_helper'

describe 'Version in Accept Header' do
  include DefaultUserAgent

  context 'Accept Header is properly formatted' do
    before :each do
      create(:organization)
      get(
        'api/organizations',
        {},
        'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json',
        'HTTP_ORIGIN' => 'http://ohanapi.org'
      )
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'retrieves a content-type of json' do
      headers['Content-Type'].should include 'application/json'
    end
  end

  context 'Accept Header is not properly formatted' do
    before :each do
      create(:organization)
      headers = {
        'HTTP_ACCEPT' => 'application/vnd.ohanapi.v1+json',
        'HTTP_ORIGIN' => 'http://ohanapi.org'
      }
      get 'api/organizations', {}, headers
    end

    # For a 406 to be returned, the cascade: false option must be
    # added to the version info in api.rb, but that prevents the
    # api/docs page from loading. Need to investigate or move docs
    # out of api path.
    xit 'returns a 406 response' do
      expect(response.status).to eq(406)
    end
  end

  context 'Accept Header is not present' do
    before :each do
      create(:organization)
      get(
        'api/organizations',
        {},
        'HTTP_ACCEPT' => '',
        'HTTP_ORIGIN' => 'http://ohanapi.org'
      )
    end

    it 'returns a 200 response' do
      expect(response.status).to eq(200)
    end
  end
end
