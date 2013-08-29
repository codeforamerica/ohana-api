require 'spec_helper'

describe "Home" do
  include DefaultUserAgent

  context "when visit non-api path after visiting api path" do

    before :each do
      get 'api/organizations'
      get "/"
      etag = headers['ETag']
      get '/', {}, { 'HTTP_IF_NONE_MATCH' => etag }
    end

    it "doesn't change the rate limit REDIS key" do
      key = REDIS.get "ohanapi_defender:127.0.0.1:#{Time.now.strftime('%Y-%m-%dT%H')}"
      expect(key).to eq("1")
    end

    it 'does not return the requests limit headers' do
      headers.keys.should_not include("X-RateLimit-Limit")
    end

  end
end