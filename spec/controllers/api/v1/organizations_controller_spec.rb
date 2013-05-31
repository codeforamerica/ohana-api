require 'spec_helper'

describe Api::V1::OrganizationsController do

	describe "GET 'index'" do
    it "should be paginated" do
      organization = create(:organization) #shortcut for FactoryGirl.create
      get :index
      response.should be_paginated_resource
    end

    it "should include the name in the response" do
      organization = create(:organization) #shortcut for FactoryGirl.create
      get :index
      response.parsed_body["response"].first["name"].should == "Burlingame, Easton Branch"
    end
  end
end