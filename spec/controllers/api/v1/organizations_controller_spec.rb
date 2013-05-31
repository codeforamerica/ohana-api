require 'spec_helper'

describe Api::V1::OrganizationsController do

	let(:content_body) { response.decoded_body.response }

	describe "GET 'index'" do
    it "should be paginated" do
      organization = create(:organization)
      get :index
      response.should be_paginated_resource
    end

    it "should include the name in the response" do
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

		  it 'should have the correct status code' do
		    response.should be_successful
		  end

		  it 'should be json' do
		    response.content_type.should == 'application/json'
		  end

		  it 'should have the farmers market name' do
		    content_body.name.should == 'Pescadero Grown'
		  end

		  it 'should include products_sold' do
		    content_body.products_sold.should be_present
		    content_body.products_sold.should be_a Array
		    ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs", "Vegetables", "Jams", "Meat", "Nursery", "Plants", "Poultry"].each do |product|
		      content_body.products_sold.should include(product)
		    end
		  end

		  it 'should be the correct type of response' do
		    response.should be_singular_resource
		  end
		end

		context 'with invalid data' do

		  before :each do
		    org = Organization.find_by_keyword('12345').should be_blank
		    get :show, :id => org
		  end

		  it 'should return a not found error' do
		    response.should be_api_error RocketPants::NotFound
		  end

		  it 'should have the correct status code' do
		    response.status.should == 404
		  end

		  it 'should be json' do
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

		  it 'should have the correct status code' do
		    response.should be_successful
		  end

		  it 'should be json' do
		    response.content_type.should == 'application/json'
		  end

		  it 'should have the farmers market name' do
		    response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
		  end

		  it 'should include products_sold' do
		    products_sold = response.parsed_body["response"].first["products_sold"]
		    products_sold.should be_present
		    products_sold.should be_a Array
		    ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs", "Vegetables", "Jams", "Meat", "Nursery", "Plants", "Poultry"].each do |product|
		      products_sold.should include(product)
		    end
		  end

		  it 'should be the correct type of response' do
		    response.should be_paginated_resource
		  end
		end

		context 'with invalid radius' do

		  before :each do
		    organization = create(:farmers_market)
		    get :search, :keyword => "market", :radius => "ads"
		  end

		  it 'should return a bad request error' do
		    response.should be_api_error RocketPants::BadRequest
		  end

		  it 'should have the correct status code' do
		    response.status.should == 400
		  end

		  it 'should be json' do
		    response.content_type.should == 'application/json'
		  end

		  it 'should include a specific_reason' do
		    response.parsed_body["specific_reason"].should == "radius must be a number"
		  end
		end

		context 'with radius too small but within range' do
		  it 'should have the farmers market name' do
		  	organization = create(:farmers_market)
		    get :search, :keyword => "market", :location => "la honda, ca", :radius => 0.05
		    response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
		  end
		end

		context 'with radius too big but within range' do
		  it 'should have the farmers market name' do
		  	organization = create(:farmers_market)
		    get :search, :keyword => "market", :location => "San Gregorio, CA", :radius => 50
		    response.parsed_body["response"].first["name"].should == 'Pescadero Grown'
		  end
		end

		context 'with radius not within range' do
		  it 'should have the farmers market name' do
		  	organization = create(:farmers_market)
		    get :search, :keyword => "market", :location => "Pescadero, ca", :radius => 5
		    response.parsed_body["response"].should == []
		  end
		end

		context 'with invalid zip' do
		  it 'should include an invalid zip code or address specific_reason' do
		  	organization = create(:farmers_market)
		    get :search, :keyword => "market", :radius => 2, :location => 00000
		    response.parsed_body["specific_reason"].should == "Invalid ZIP code or address"
		  end
		end

		context 'with invalid location' do
		  it 'should include an invalid zip code or address specific_reason' do
		  	organization = create(:farmers_market)
		    get :search, :keyword => "market", :radius => 2, :location => "94403a"
		    response.parsed_body["specific_reason"].should == "Invalid ZIP code or address"
		  end
		end

	end
end