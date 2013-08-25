require 'spec_helper'

describe "API token in request" do
  include DefaultUserAgent
  let(:valid_attributes) { { name: "test app",
                           main_url: "http://localhost:8080",
                           callback_url: "http://localhost:8080" } }

  before (:each) do
    user = FactoryGirl.create(:user)
    api_application = user.api_applications.create! valid_attributes
    @token = api_application.api_token
  end
  context "when the rate limit has not been reached" do
    before { get 'api/organizations', {}, { 'HTTP_X_API_TOKEN' => @token } }

    it 'returns the requests limit headers' do
      headers['X-RateLimit-Limit'].should == "5000"
    end

    it 'returns the remaining requests header' do
      headers['X-RateLimit-Remaining'].should == "4999"
    end
  end

  context "when the rate limit has been reached" do

    before :each do
      key = "ohanapi_defender:127.0.0.1:#{Time.now.strftime('%Y-%m-%dT%H')}"
      REDIS.set(key, "5000")
      get 'api/organizations', {}, { 'HTTP_X_API_TOKEN' => @token }
    end

    it_behaves_like "rate limit reached"
  end

  describe "when the 'If-None-Match' header is passed in the request" do
    context 'when the ETag has not changed' do

      before :each do
        get 'api/organizations'
        etag = headers['ETag']
        get 'api/organizations', {},
          { 'HTTP_IF_NONE_MATCH' => etag, 'HTTP_X_API_TOKEN' => @token }
      end

      it 'returns a 304 status' do
        response.status.should == 304
      end

      it 'returns the requests limit headers' do
        headers['X-RateLimit-Limit'].should == "5000"
      end

      it 'does not decrease the remaining requests' do
        headers['X-RateLimit-Remaining'].should == "4999"
      end
    end

    context 'when the ETag has changed' do

      before :each do
        organization = create(:organization)
        get 'api/organizations'
        get 'api/organizations', {},
          { 'HTTP_IF_NONE_MATCH' => "1234567890", 'HTTP_X_API_TOKEN' => @token }
      end

      it 'returns a 200 status' do
        response.status.should == 200
      end

      it 'returns the requests limit headers' do
        headers['X-RateLimit-Limit'].should == "5000"
      end

      it 'decreases the remaining requests' do
        headers['X-RateLimit-Remaining'].should == "4998"
      end
    end
  end
end