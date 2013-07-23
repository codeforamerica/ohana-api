require 'spec_helper'

describe Api::V1::OrganizationsController do

  let(:content_body) { response.decoded_body.response }

  describe "GET 'index'" do
    it "is paginated" do
      organization = create(:organization)
      get :index
      response.should be_paginated_resource
    end

    it "includes the name in the response" do
      organization = create(:organization)
      get :index
      name = response.parsed_body["response"].first["name"]
      name.should == "Parent Agency"
    end
  end

  describe "GET 'show'" do
    context 'with valid data' do

      before :each do
        organization = create(:organization)
        get :show, :id => organization
      end

      it 'returns a successful status code' do
        response.should be_successful
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'returns the farmers market name' do
        content_body.name.should == "Parent Agency"
      end

      it 'is a singular resource' do
        response.should be_singular_resource
      end
    end

    context 'with invalid data' do

      before :each do
        org = Organization.where(name: '12345').should be_blank
        get :show, :id => org
      end

      it 'returns a not found error' do
        response.should be_api_error RocketPants::NotFound
      end

      it 'returns a 404 status code' do
        response.status.should == 404
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end
    end
  end
end