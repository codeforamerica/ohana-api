require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent
  include Features::SessionHelpers

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
        location = create(:location)
        get "api/search?location=94403&radius=ads"
      end

      it 'returns a 400 status code' do
        response.status.should == 400
      end

      it 'is json' do
        response.content_type.should == 'application/json'
      end

      it 'includes an error description' do
        json["error"].should == "radius is invalid"
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
        create_service
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
        create_service
        get "api/search?keyword=emergencies"
        keywords = json.first["services"].first["keywords"]
        keywords.should include "emergency"
      end
    end

    context "with kind parameter" do
      before(:each) do
        loc1 = create(:location)
        loc2 = create(:nearby_loc)
        loc3 = create(:no_address)
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

      it "filters out kind=other" do
        get "api/search?exclude=Other"
        headers["X-Total-Count"].should == "2"
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
        cat = create(:category)
        create_service
        @service.category_ids = [cat.id]
        @service.save
        @location.index.refresh
      end
      it "boosts location whose services category name matches the query" do
        get "api/search?keyword=food"
        headers["X-Total-Count"].should == "3"
        json.first["name"].should == "VRS Services"
      end
    end

    context "with category parameter" do
      before(:each) do
        create(:nearby_loc)
        create(:farmers_market_loc)
        cat = create(:jobs)
        create_service
        @service = @location.services.first
        @service.category_ids = [cat.id]
        @service.save
        @location.index.refresh
      end

      it "only returns locations whose category name matches the query" do
        get "api/search?category=Jobs"
        headers["X-Total-Count"].should == "1"
        json.first["name"].should == "VRS Services"
      end

      it "only finds exact spelling matches for the category" do
        get "api/search?category=jobs"
        headers["X-Total-Count"].should == "0"
      end

      it "includes the depth attribute" do
        get "api/search?category=Jobs"
        expect(json.first["services"].first["categories"].first["depth"]).
          to eq 0
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

    context "with domain parameter" do
      it "finds domain name when url contains 'www'" do
        create(:location, urls:["http://www.smchsa.org"])
        create(:location, emails:["info@cfa.org"])
        get "api/search?domain=smchsa.org"
        headers["X-Total-Count"].should == "1"
      end

      it "finds naked domain name" do
        create(:location, urls:["http://smchsa.com"])
        create(:location, emails:["hello@cfa.com"])
        get "api/search?domain=smchsa.com"
        headers["X-Total-Count"].should == "1"
      end

      it "finds long domain name in both url and email" do
        create(:location, urls:["http://smchsa.org"])
        create(:location, emails:["info@smchsa.org"])
        get "api/search?domain=smchsa.org"
        headers["X-Total-Count"].should == "2"
      end

      it "finds domain name when URL contains path" do
        create(:location, urls:["http://www.smchealth.org/mcah"])
        create(:location, emails:["org@mcah.org"])
        get "api/search?domain=smchealth.org"
        headers["X-Total-Count"].should == "1"
      end

      it "finds domain name when URL contains multiple paths" do
        create(:location, urls:["http://www.smchsa.org/portal/site/planning"])
        create(:location, emails:["sanmateo@ca.us"])
        get "api/search?domain=smchsa.org"
        headers["X-Total-Count"].should == "1"
      end

      it "finds domain name when URL contains a dash" do
        create(:location, urls:["http://www.childsup-connect.ca.gov"])
        create(:location, emails:["gov@childsup-connect.gov"])
        get "api/search?domain=childsup-connect.ca.gov"
        headers["X-Total-Count"].should == "1"
      end

      it "finds domain name when URL contains a number" do
        create(:location, urls:["http://www.prenatalto3.org"])
        create(:location, emails:["info@rwc2020.org"])
        get "api/search?domain=prenatalto3.org"
        headers["X-Total-Count"].should == "1"
      end

      it "doesn't return results for gmail domain" do
        create(:location, emails:["info@gmail.com"])
        get "api/search?domain=gmail.com"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for aol domain" do
        create(:location, emails:["info@aol.com"])
        get "api/search?domain=aol.com"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for hotmail domain" do
        create(:location, emails:["info@hotmail.com"])
        get "api/search?domain=hotmail.com"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for yahoo domain" do
        create(:location, emails:["info@yahoo.com"])
        get "api/search?domain=yahoo.com"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for sbcglobal domain" do
        create(:location, emails:["info@sbcglobal.net"])
        get "api/search?domain=sbcglobal.net"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for co.sanmateo.ca.us domain" do
        create(:location, emails:["info@co.sanmateo.ca.us"])
        get "api/search?domain=co.sanmateo.ca.us"
        headers["X-Total-Count"].should == "0"
      end

      it "doesn't return results for smcgov.org domain" do
        create(:location, emails:["info@smcgov.org"])
        get "api/search?domain=smcgov.org"
        headers["X-Total-Count"].should == "0"
      end
    end

    context "when email parameter only contains domain name" do
      it "doesn't return results" do
        create(:location, emails:["info@gmail.com"])
        get "api/search?email=gmail.com"
        headers["X-Total-Count"].should == "0"
      end
    end

    context "when email parameter contains full email address" do
      it "returns locations where either emails or admins fields match" do
        create(:location, emails:["moncef@smcgov.org"])
        create(:location_with_admin)
        get "api/search?email=moncef@smcgov.org"
        headers["X-Total-Count"].should == "2"
      end
    end

    context "when email parameter contains full email address" do
      it "only returns locations where admin email is exact match" do
        create(:location, emails:["moncef@smcgov.org"])
        create(:location_with_admin)
        get "api/search?email=moncef@gmail.com"
        headers["X-Total-Count"].should == "0"
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