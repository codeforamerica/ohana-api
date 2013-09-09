require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent

  describe "GET 'search'" do
    context "when none of the required parameters are present" do
      before :each do
        create(:location)
        get "/api/search?zoo=far"
      end

      it 'returns a 400 bad request status code' do
        response.status.should == 400
      end

      it 'includes an error description' do
        json["description"].should == "Either keyword, location, or language is missing."
      end
    end

    context 'with valid keyword only' do
      before :each do
        @locations = create_list(:farmers_market_loc, 2)
        get "/api/search?keyword=market"
      end

      it 'returns a successful status code' do
        response.should be_successful
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'returns locations' do
        json.first["name"].should == "Belmont Farmers Market"
      end

      it 'includes products_sold' do
        products = json.first["products"]
        products.should be_present
        products.should be_a Array
        ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"].each do |product|
          products.should include(product)
        end
      end

      it 'is a paginated resource' do
        get "/api/search?keyword=market&page=2"
        json.length.should == 1
        json.first["name"].should == @locations.last.name
      end

      it "returns an X-Total-Count header" do
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["X-Total-Count"].should == "2"
      end
    end

    context 'with invalid radius' do
      before :each do
        location = create(:farmers_market_loc)
        get "api/search?location=94403&radius=ads"
      end

      it 'returns a 400 status code' do
        response.status.should == 400
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'includes an error description' do
        json["error"].should == "invalid parameter: radius"
      end
    end

    context 'with radius too small but within range' do
      it 'returns the farmers market name' do
        location = create(:farmers_market_loc)
        get "api/search?location=la%20honda,%20ca&radius=0.05"
        json.first["name"].should == "Belmont Farmers Market"
      end
    end

    context 'with radius too big but within range' do
      it 'returns the farmers market name' do
        location = create(:farmers_market_loc)
        get "api/search?location=san%20gregorio,%20ca&radius=50"
        json.first["name"].should == "Belmont Farmers Market"
      end
    end

    context 'with radius not within range' do
      it 'returns an empty response array' do
        location = create(:farmers_market_loc)
        get "api/search?location=pescadero,%20ca&radius=5"
        json.should == []
      end
    end

    context 'with invalid zip' do
      it "specifies that an 'Invalid ZIP code or address' was passed" do
        location = create(:farmers_market_loc)
        get "api/search?location=00000"
        json["description"].should == "Invalid ZIP code or address."
      end
    end

    context 'with invalid location' do
      it "specifies that an 'Invalid ZIP code or address' was passed" do
        location = create(:farmers_market_loc)
        get "api/search?location=94403ab"
        json["description"].should == "Invalid ZIP code or address."
      end
    end

    context "when keyword only matches one location" do
      it "only returns 1 result" do
        loc1 = create(:location)
        loc2 = create(:nearby_loc)
        get "api/search?keyword=library"
        json.length.should == 1
      end
    end

    context "when keyword doesn't match anything" do
      it "returns no results" do
        loc1 = create(:location)
        loc2 = create(:nearby_loc)
        get "api/search?keyword=blahab"
        json.length.should == 0
      end
    end

    context "with language parameter" do
      it "finds organizations that match the language" do
        loc1 = create(:location)
        loc2 = create(:nearby_loc)
        get "api/search?keyword=library&language=arabic"
        json.first["name"].should == "Library"
      end
    end

    context 'with singular version of keyword' do
      it "finds the plural occurrence in location's name field" do
        create(:location)
        get "api/search?keyword=service"
        json.first["name"].should == "VRS Services"
      end

      it "finds the plural occurrence in location's description field" do
        create(:location)
        get "api/search?keyword=job"
        json.first["description"].should == "Provides jobs training"
      end

      it "finds the plural occurrence in organization name field" do
        create(:nearby_loc)
        get "api/search?keyword=food%20stamp"
        json.first["organization"]["name"].should == "Food Stamps"
      end

      it "finds the plural occurrence in service's keywords field" do
        create(:service)
        get "api/search?keyword=pantry"
        keywords = json.first["services"].first["keywords"]
        keywords.should include "food pantries"
      end
    end

    context 'with plural version of keyword' do
      it "finds the plural occurrence in location's name field" do
        create(:location)
        get "api/search?keyword=services"
        json.first["name"].should == "VRS Services"
      end

      it "finds the plural occurrence in location's description field" do
        create(:location)
        get "api/search?keyword=jobs"
        json.first["description"].should == "Provides jobs training"
      end

      it "finds the plural occurrence in organization name field" do
        create(:nearby_loc)
        get "api/search?keyword=food%20stamps"
        json.first["organization"]["name"].should == "Food Stamps"
      end

      it "finds the plural occurrence in service's keywords field" do
        create(:service)
        get "api/search?keyword=emergencies"
        keywords = json.first["services"].first["keywords"]
        keywords.should include "emergency"
      end
    end

    describe 'sorting search results' do
      context 'sort when neither keyword nor location is not present' do
        it 'returns a helpful message about search query requirements' do
          get "api/search?sort=name"
          json["description"].should == "Either keyword, location, or language is missing."
        end
      end

      context 'sort when only location is present' do
        it 'sorts by distance by default' do
          loc1 = create(:location)
          loc2 = create(:nearby_loc)
          get "api/search?location=1236%20Broadway,%20Burlingame,%20CA%2094010"
          json.first["name"].should == "VRS Services"
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
  end
end