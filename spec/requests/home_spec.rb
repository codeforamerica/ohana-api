require 'spec_helper'

describe 'Home' do
  include DefaultUserAgent

  context 'when visit non-api path after visiting api path' do

    before :each do
      get 'api/organizations'
      get '/'
      etag = headers['ETag']
      get '/', {}, 'HTTP_IF_NONE_MATCH' => etag
    end

    xit "doesn't change the rate limit REDIS key" do
      key = REDIS.get "throttle:127.0.0.1:#{Time.now.strftime('%Y-%m-%dT%H')}"
      expect(key).to eq('1')
    end

    it 'does not return the requests limit headers' do
      headers.keys.should_not include('X-RateLimit-Limit')
    end

  end

  context 'when visit non-api path with valid Accept header' do

    before :each do
      get '/', {}, 'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json'
    end

    it "doesn't throw a 500 error due to ActionView::MissingTemplate" do
      response.status.should == 406
    end

  end
end
