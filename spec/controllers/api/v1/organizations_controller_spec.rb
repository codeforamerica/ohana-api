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
      response.parsed_body["response"].first["name"].should == "Burlingame, Easton Branch"
    end
  end

  describe "GET 'show'" do
    context 'with valid data' do

      before :each do
        organization = create(:farmers_market)
        get :show, :id => organization
      end

      it 'returns a successful status code' do
        response.should be_successful
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'returns the farmers market name' do
        content_body.name.should == 'Pescadero Grown'
      end

      it 'returns products_sold' do
        content_body.products_sold.should be_present
        content_body.products_sold.should be_a Array
        ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"].each do |product|
          content_body.products_sold.should include(product)
        end
      end

      it 'is a singular resource' do
        response.should be_singular_resource
      end
    end

    context 'with invalid data' do

      before :each do
        org = Organization.find_by_keyword('12345').should be_blank
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

  describe "GET 'search'" do
    context 'with valid keyword only' do

      before :each do
        organization = create(:farmers_market)
        get :search, :keyword => "market"
      end

      it 'returns a successful status code' do
        response.should be_successful
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'returns the farmers market name' do
        response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
      end

      it 'includes products_sold' do
        products_sold = response.parsed_body["response"].first["products_sold"]
        products_sold.should be_present
        products_sold.should be_a Array
        ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"].each do |product|
          products_sold.should include(product)
        end
      end

      it 'is a paginated resource' do
        response.should be_paginated_resource
      end
    end

    context 'with invalid radius' do

      before :each do
        organization = create(:farmers_market)
        get :search, :keyword => "parks", :location => "94403", :radius => "ads"
      end

      it 'returns a bad request error' do
        response.should be_api_error RocketPants::BadRequest
      end

      it 'returns a 400 status code' do
        response.status.should == 400
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'includes a specific_reason' do
        response.parsed_body["specific_reason"].should == "radius must be a number"
      end
    end

    context 'with radius too small but within range' do
      it 'returns the farmers market name' do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :location => "la honda, ca", :radius => 0.05
        response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
      end
    end

    context 'with radius too big but within range' do
      it 'returns the farmers market name' do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :location => "San Gregorio, CA", :radius => 50
        response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
      end
    end

    context 'with radius not within range' do
      it 'returns an empty response array' do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :location => "Pescadero, ca", :radius => 5
        response.parsed_body["response"].should == []
      end
    end

    context 'with invalid zip' do
      it "returns an error with an 'Invalid ZIP code or address' specific_reason" do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :radius => 2, :location => 00000
        response.parsed_body["specific_reason"].should == "Invalid ZIP code or address"
      end
    end

    context 'with invalid location' do
      it "returns an error with an 'Invalid ZIP code or address' specific_reason" do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :radius => 2, :location => "94403a"
        response.parsed_body["specific_reason"].should == "Invalid ZIP code or address"
      end
    end
  end

  describe 'sorting search results' do
    context 'sort when neither keyword nor location is not present' do
      it 'returns a helpful error message about the sort parameter requirements' do
        get :search, :sort => "name"
        response.parsed_body["specific_reason"].should ==
        "Search requires at least one of keyword or location"
      end
    end

    context 'sort when only location is present' do
      it 'sorts by distance by default' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "94010"
        response.parsed_body["count"].should == 2
        response.parsed_body["response"].first["name"].should == 'Redwood City Main'
      end
    end

    context 'sort when location and sort are present' do
      it 'sorts by distance and sorts by name asc by default' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "94010", :sort => "name"
        response.parsed_body["count"].should == 2
        response.parsed_body["response"][0]["name"].should == 'Burlingame, Easton Branch'
      end
    end

    context 'sort when location and sort are present, and order is specified' do
      it 'sorts by distance and sorts by name and order desc' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "94010", :sort => "name", :order => "desc"
        response.parsed_body["count"].should == 2
        response.parsed_body["response"][0]["name"].should == 'Redwood City Main'
      end
    end
  end
end