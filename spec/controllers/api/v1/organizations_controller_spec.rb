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
      name.should == "Burlingame, Easton Branch"
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
        get :show, :id => "123456"
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
    context 'when search term matches keyword' do
      it 'boosts orgs with the search term in keywords field' do
        org1 = create(:food_stamps_keyword)
        org2 = create(:food_stamps_name)
        get :search, :keyword => "Care "
        response.parsed_body["count"].should == 2
        name = response.parsed_body["response"].first["name"]
        name.should == 'Food Stamps'
      end
    end

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
        name = response.parsed_body["response"].first["name"]
        name.should == 'Pescadero Grown'
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
        get :search, keyword: "parks", location: "94403", radius: "ads"
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
        specific_reason = response.parsed_body["specific_reason"]
        specific_reason.should == "radius must be a number."
      end
    end

    context 'with radius too small but within range' do
      it 'returns the farmers market name' do
        organization = create(:farmers_market)
        get :search, keyword: "market", location: "la honda, ca", radius: 0.05
        name = response.parsed_body["response"].first["name"]
        name.should == 'Pescadero Grown'
      end
    end

    context 'with radius too big but within range' do
      it 'returns the farmers market name' do
        organization = create(:farmers_market)
        get :search, keyword: "market", location: "San Gregorio, CA", radius: 50
        name = response.parsed_body["response"].first["name"]
        name.should == 'Pescadero Grown'
      end
    end

    context 'with radius not within range' do
      it 'returns an empty response array' do
        organization = create(:farmers_market)
        get :search, keyword: "market", location: "Pescadero, ca", radius: 5
        response.parsed_body["response"].should == []
      end
    end

    context 'with invalid zip' do
      it "specifies that an 'Invalid ZIP code or address' was passed" do
        organization = create(:farmers_market)
        get :search, :keyword => "market", :radius => 2, :location => "00000"
        specific_reason = response.parsed_body["specific_reason"]
        specific_reason.should == "Invalid ZIP code or address."
      end
    end

    context 'with invalid location' do
      it "specifies that an 'Invalid ZIP code or address' was passed" do
        organization = create(:farmers_market)
        get :search, keyword: "market", radius: 2, location: "94403ab"
        specific_reason = response.parsed_body["specific_reason"]
        specific_reason.should == "Invalid ZIP code or address."
      end
    end

    context 'with singular version of keyword' do
      it "finds the plural occurrence as well in name field" do
        organization = create(:food_stamps_name)
        get :search, keyword: "food stamp"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Food Stamps'
      end

      it "finds the plural occurrence as well in description field" do
        organization = create(:food_stamps_description)
        get :search, keyword: "food stamp"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House'
      end

      it "finds the plural occurrence as well in agency field" do
        organization = create(:food_stamps_agency)
        get :search, keyword: "food stamp"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House'
      end

      it "finds the plural occurrence as well in keyword field" do
        organization = create(:food_stamps_keyword)
        get :search, keyword: "food stamp"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House Care'
      end
    end

    context 'with plural version of keyword' do
      it "finds the plural occurrence as well in name field" do
        organization = create(:food_stamps_name)
        get :search, keyword: "food stamps"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Food Stamps'
      end

      it "finds the plural occurrence as well in description field" do
        organization = create(:food_stamps_description)
        get :search, keyword: "food stamps"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House'
      end

      it "finds the plural occurrence as well in agency field" do
        organization = create(:food_stamps_agency)
        get :search, keyword: "food stamps"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House'
      end

      it "finds the plural occurrence as well in keyword field" do
        organization = create(:food_stamps_keyword)
        get :search, keyword: "food stamps"
        name = response.parsed_body["response"].first["name"]
        name.should == 'Samaritan House Care'
      end
    end

    context "with language parameter" do
      it "finds organizations that match the language" do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, keyword: "library", :language => "Spanish"
        response.parsed_body["count"].should == 1
        name = response.parsed_body["response"].first["name"]
        name.should == 'Burlingame, Easton Branch'
      end
    end
  end

  describe 'sorting search results' do
    context 'sort when neither keyword nor location is not present' do
      it 'returns a helpful message about search query requirements' do
        get :search, :sort => "name"
        response.parsed_body["specific_reason"].should ==
        "Either keyword, location, or language is missing."
      end
    end

    context 'sort when only location is present' do
      it 'sorts by distance by default' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "1236 Broadway, Burlingame, CA 94010"
        response.parsed_body["count"].should == 2
        name = response.parsed_body["response"].first["name"]
        name.should == 'Redwood City Main'
      end
    end

    context 'sort when location and sort are present' do
      xit 'sorts by distance and sorts by name asc by default' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "94010", :sort => "name"
        response.parsed_body["count"].should == 2
        name = response.parsed_body["response"][0]["name"]
        name.should == 'Burlingame, Easton Branch'
      end
    end

    context 'sort when location and sort are present, & order is specified' do
      xit 'sorts by distance and sorts by name and order desc' do
        organization = create(:organization)
        nearby = create(:nearby_org)
        get :search, :location => "94010", :sort => "name", :order => "desc"
        response.parsed_body["count"].should == 2
        name = response.parsed_body["response"][0]["name"]
        name.should == 'Redwood City Main'
      end
    end
  end

  describe "GET 'nearby'" do
    before :each do
      @organization = create(:organization)
      nearby = create(:nearby_org)
      far = create(:food_stamps_agency)
    end

    it "is paginated" do
      get :nearby, :id => @organization
      response.should be_paginated_resource
    end

    context 'with no radius' do
      it "displays nearby locations within 5 miles" do
        get :nearby, :id => @organization
        response.parsed_body["count"].should == 2
        name = response.parsed_body["response"][1]["name"]
        name.should == 'Samaritan House'
      end
    end

    context 'with valid radius' do
      it "displays nearby locations within 1 mile" do
        get :nearby, :id => @organization, :radius => 1
        response.parsed_body["count"].should == 1
        name = response.parsed_body["response"][0]["name"]
        name.should == 'Redwood City Main'
      end
    end

    context 'with invalid radius' do
      it "returns 'invalid radius' message" do
        get :nearby, :id => @organization, :radius => "<script>"
        specific_reason = response.parsed_body["specific_reason"]
        specific_reason.should == "radius must be a number."
      end
    end
  end
end