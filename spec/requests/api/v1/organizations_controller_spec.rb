require 'spec_helper'

describe Api::V1::OrganizationsController do

	describe "CORS REQUESTS" do
		context "when ORIGIN is specified" do
			before :each do
				organization = create(:organization)
				get 'api/organizations', {}, {'Accept' => 'application/vnd.ohanapi+json; version=1', 'HTTP_ORIGIN' => 'http://ohanapi.org'}
			end

		  it "gets version 1" do
		    response.status.should == 200
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
	  		get 'api/organizations', {}, {}
	      headers.keys.should_not include("Access-Control-Allow-Origin")
	      headers['Access-Control-Allow-Origin'].should be_nil
	    end
	  end
	end

  context "when the rate limit has not been reach" do
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

	  it 'returns a 403 status' do
    	response.status.should == 403
    end

    it 'returns a rate limited exceeded body' do
    	parsed_body = JSON.parse(response.body)
      parsed_body["description"].should == 'Rate limit exceeded'
    end

    it 'does not return the remaining requests header' do
      headers['X-RateLimit-Remaining'].should be_nil
    end
  end
end