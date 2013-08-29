require 'spec_helper'

describe "CORS REQUESTS" do
  context "when ORIGIN is specified" do
    before :each do
      organization = create(:organization)
      get 'api/organizations', {},
        { 'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json',
          'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => "Rspec" }
    end

    it "gets version 1" do
      #response.status.should == 200
      expect(response).to be_success
    end

    it "retrieves a content-type of json" do
      headers['Content-Type'].should include 'application/json'
    end

    it "includes CORS headers when ORIGIN is specified" do
      headers.keys.should include("Access-Control-Allow-Origin")
      headers['Access-Control-Allow-Origin'].should == 'http://ohanapi.org'
    end

    it "allows GET, POST, & PUT HTTP methods thru CORS" do
      allowed_http_methods = headers['Access-Control-Allow-Methods']
      %w{GET POST PUT}.each do |method|
        allowed_http_methods.should include(method)
      end
    end
  end

  context "when ORIGIN is not specified" do
    it "does not include CORS headers when ORIGIN is not specified" do
      get 'api/organizations', {}, { 'HTTP_USER_AGENT' => "Rspec" }
      response.status.should == 200
      headers.keys.should_not include("Access-Control-Allow-Origin")
      headers['Access-Control-Allow-Origin'].should be_nil
    end
  end
end