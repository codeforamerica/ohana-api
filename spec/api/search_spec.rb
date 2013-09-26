require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent

  describe "GET 'search'" do
    context "when none of the required parameters are present" do
      before :each do
        create(:location)
        get "/api/search?zoo=far"
      end

      xit 'returns a 400 bad request status code' do
        response.status.should == 400
      end

      xit 'includes an error description' do
        json["description"].
          should == "Either keyword, location, or language is missing."
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

      it 'includes products' do
        products = json.first["products"]
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

    context "with kind parameter" do
      before(:each) do
        loc1 = create(:location)
        loc2 = create(:nearby_loc)
        loc3 = create(:farmers_market_loc)
        loc4 = create(:no_address)
      end
      it "finds farmers markets" do
        get "api/search?kind=farmers'%20markets"
        json.length.should == 1
        json.first["name"].should == "Belmont Farmers Market"
      end

      it "finds human services" do
        get "api/search?kind=Human%20services"
        json.length.should == 1
        json.first["name"].should == "Library"
      end

      it "finds other" do
        get "api/search?kind=other"
        json.length.should == 1
        json.first["name"].should == "VRS Services"
      end

      it "filters out everything except kind=human and kind is not set" do
        get "api/search?exclude=market_other"
        headers["X-Total-Count"].should == "1"
      end

      it "filters out kind=other and kind=test" do
        get "api/search?exclude=Other"
        headers["X-Total-Count"].should == "2"
      end

      it "filters out kind=test" do
        get "api/locations"
        headers["X-Total-Count"].should == "3"
      end

      it "allows multiple kinds" do
        get "api/search?kind[]=Other&kind[]=human%20Services"
        headers["X-Total-Count"].should == "2"
      end

      it "allows sorting by kind (default order is asc)" do
        get "api/search?kind[]=Other&kind[]=Human%20services&sort=kind"
        headers["X-Total-Count"].should == "2"
        json.first["name"].should == "Library"
      end

      it "allows sorting by kind and ordering desc)" do
        get "api/search?kind[]=Other&kind[]=human%20services&sort=kind&order=desc"
        headers["X-Total-Count"].should == "2"
        json.first["name"].should == "VRS Services"
      end
    end

    context "when keyword matches category name" do
      before(:each) do
        create(:far_loc)
        create(:farmers_market_loc)
        cat = Category.create!(:name => "food")
        FactoryGirl.create(:service_with_nil_fields,
          :category_ids => ["#{cat.id}"])
      end
      it "boosts location whose services category name matches the query" do
        get "api/search?keyword=food"
        headers["X-Total-Count"].should == "2"
        json.first["name"].should == "Belmont Farmers Market with cat"
      end
    end

    context "with category parameter" do
      before(:each) do
        create(:nearby_loc)
        create(:location)
        cat = Category.create!(:name => "Jobs")
        FactoryGirl.create(:service_with_nil_fields,
          :category_ids => ["#{cat.id}"])
      end
      it "only returns locations whose category name matches the query" do
        get "api/search?category=Jobs"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "Belmont Farmers Market with cat"
      end
      it "only finds exact spelling matches for the category" do
        get "api/search?category=jobs"
        headers["X-Total-Count"].should == "0"
      end
    end

    context "with org_name parameter" do
      before(:each) do
        create(:nearby_loc)
        create(:location)
      end
      it "only returns locations whose org name matches the query" do
        get "api/search?org_name=Food+Stamps"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "Library"
      end
    end

    context "with market_match parameter" do
      before(:each) do
        create(:farmers_market_loc)
        create(:farmers_market_loc,
          :market_match => false, :name => "Not Participating")
      end
      it "only returns farmers' markets who participate in Market Match" do
        get "api/search?market_match=1"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "Belmont Farmers Market"
      end
      it "only returns markets who don't participate in Market Match" do
        get "api/search?market_match=0"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "Not Participating"
      end
    end

    context "with payments parameter" do
      before(:each) do
        create(:farmers_market_loc)
        create(:farmers_market_loc,
          :name => "No SFMNP", :payments => ["Credit"])
      end
      it "only returns farmers' markets who accept SFMNP" do
        get "api/search?payments=SFMNP"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "Belmont Farmers Market"
      end
    end

    context "with products parameter" do
      before(:each) do
        create(:farmers_market_loc)
        create(:farmers_market_loc,
          :name => "No Cheese", :products => ["Baked Goods"])
      end
      it "only returns farmers' markets who sell Baked Goods" do
        get "api/search?products=baked%20goods"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "No Cheese"
      end
      it "finds a match when query is capitalized" do
        get "api/search?products=Baked%20Goods"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "No Cheese"
      end
    end

    describe 'sorting search results' do
      context "general keyword search" do
        before(:each) do
          loc1 = create(:location)
          loc2 = create(:nearby_loc)
          loc3 = create(:farmers_market_loc)
          loc4 = create(:no_address)
        end
        it "favors human services" do
          get "api/search?keyword=jobs"
          headers["X-Total-Count"].should == "3"
          json.first["name"].should == "Library"
        end
      end
      context 'sort when neither keyword nor location is not present' do
        xit 'returns a helpful message about search query requirements' do
          get "api/search?sort=name"
          json["description"].
            should == "Either keyword, location, or language is missing."
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

      context 'sort when location & sort are present, & order is specified' do
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