require 'spec_helper'

describe Api::V1::OrganizationsController do
	before :each do
		get '/api/organizations', {}, {'Accept' => 'application/vnd.ohanapi+json; version=1'}
	end

  it "should get version 1" do
    response.status.should == 200
  end

  it "should retrieve a content-type of json" do
  	response.header['Content-Type'].should include 'application/json'
  end
end