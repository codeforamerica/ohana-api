require 'spec_helper'

describe Api::V1::OrganizationsController do

	context "CORS requests with ORIGIN specified" do
		before :each do
			organization = create(:organization)
			get 'api/organizations', {}, {'Accept' => 'application/vnd.ohanapi+json; version=1', 'HTTP_ORIGIN' => 'http://ohanapi.org'}
		end

	  it "should get version 1" do
	    response.status.should == 200
	  end

	  it "should retrieve a content-type of json" do
	  	headers['Content-Type'].should include 'application/json'
	  end

		it "should include CORS headers when ORIGIN is specified" do
	    headers.keys.should include("Access-Control-Allow-Origin")
	    headers['Access-Control-Allow-Origin'].should == 'http://ohanapi.org'
	  end

	  it "should allow general HTTP methods thru CORS (GET/POST/PUT/DELETE)" do
	    allowed_http_methods = headers['Access-Control-Allow-Methods']
	    %w{GET POST PUT}.each do |method|
	      allowed_http_methods.should include(method)
	  	end
	  end
  end

  context "CORS requests with ORIGIN not specified" do
  	it "should not include CORS headers when ORIGIN is not specified" do
  		get 'api/organizations', {}, {}
      headers.keys.should_not include("Access-Control-Allow-Origin")
      headers['Access-Control-Allow-Origin'].should be_nil
    end
  end
end