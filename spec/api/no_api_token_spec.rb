require 'spec_helper'

describe "No API token in request" do
  include DefaultUserAgent
  context "when the rate limit has not been reached" do
    before { get 'api/organizations' }

    it 'returns the requests limit headers' do
      headers['X-RateLimit-Limit'].should == "60"
    end

    it 'returns the remaining requests header' do
      headers['X-RateLimit-Remaining'].should == "59"
    end
  end

  context "when the rate limit has been reached" do

    before :each do
      key = "ohanapi_defender:127.0.0.1:#{Time.now.strftime('%Y-%m-%dT%H')}"
      REDIS.set(key, "60")
      get 'api/organizations'
    end

    it_behaves_like "rate limit reached"
  end

  describe "when the 'If-None-Match' header is passed in the request" do
    context 'when the ETag has not changed' do

      before :each do
        get 'api/organizations'
        etag = headers['ETag']
        get 'api/organizations', {}, { 'HTTP_IF_NONE_MATCH' => etag }
      end

      it 'returns a 304 status' do
        response.status.should == 304
      end

      it 'returns the requests limit headers' do
        headers['X-RateLimit-Limit'].should == "60"
      end

      it 'does not decrease the remaining requests' do
        headers['X-RateLimit-Remaining'].should == "59"
      end
    end

    context 'when the ETag has changed' do

      before :each do
        get 'api/organizations'
        get 'api/organizations', {}, { 'HTTP_IF_NONE_MATCH' => "1234567890" }
      end

      it 'returns a 200 status' do
        response.status.should == 200
      end

      it 'returns the requests limit headers' do
        headers['X-RateLimit-Limit'].should == "60"
      end

      it 'decreases the remaining requests' do
        headers['X-RateLimit-Remaining'].should == "58"
      end
    end
  end
end