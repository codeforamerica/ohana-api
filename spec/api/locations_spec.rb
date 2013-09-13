require 'spec_helper'

describe Ohana::API do

  describe "Location Requests" do
    include DefaultUserAgent

    describe "GET /api/locations" do
      xit "returns an empty array when no locations exist" do
        get "/api/locations"
        expect(response).to be_success
        json.should == []
      end

      it "returns the correct number of existing locations" do
        create_list(:location, 2)
        get "/api/locations"
        expect(response).to be_success
        expect(json.length).to eq(1)
      end

      it "sorts results by creation date descending" do
        loc1 = create(:location)
        sleep 1
        loc2 = create(:nearby_loc)
        get "/api/locations?page=2"
        expect(response).to be_success
        expect(json.length).to eq(1)
        expect(json.first["accessibility"]).
          to eq(["Information on tape or in Braille", "Disabled Parking"])
        expect(json.first["kind"]).to eq("Other")
        expect(json.first["organization"].keys).to include("locations_url")
        expect(json.first["url"]).
          to eq("http://example.com/api/locations/#{loc1.id}")
        expect(json.first["organization"]["url"]).
          to eq("http://example.com/api/organizations/#{loc1.organization.id}")
      end

      it "returns the correct info about the locations" do
        create(:location)
        get "/api/locations"
        json.first["address"]["street"].should == "1800 Easton Drive"
      end
    end

    describe "GET /api/locations/:id" do
      context 'with valid data' do
        before :each do
          service = create(:service)
          @location = service.location
          get "/api/locations/#{@location.id}"
        end

        it "returns a status by id" do
          represented = {
            "id" => "#{@location.id}",
            "accessibility"=>["Information on tape or in Braille", "Disabled Parking"],
            "address" => {
              "street" => @location.address.street,
              "city" => @location.address.city,
              "state" => @location.address.state,
              "zip" => @location.address.zip
            },
            "coordinates" => @location.coordinates,
            "description" => @location.description,
            "kind"=>"Other",
            "name" => @location.name,
            "phones" => [{
              "number" => "650 851-1210",
              "department" => "Information",
              "phone_hours" => "(Monday-Friday, 9-12, 1-5)"
            }],
            "updated_at" => @location.updated_at.strftime("%Y-%m-%dT%H:%M:%S%:z"),
            "url" => "http://example.com/api/locations/#{@location.id}",
            "services" => [{
              "id" => "#{@location.services.first.id}",
              "description" => @location.services.first.description,
              "keywords" => @location.services.first.keywords,
              "name" => @location.services.first.name,
              "updated_at" => @location.services.first.updated_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
            }],
            "organization" => {
              "id" => "#{@location.organization.id}",
              "name"=> "Parent Agency",
              "url" => "http://example.com/api/organizations/#{@location.organization.id}",
              "locations_url" => "http://example.com/api/organizations/#{@location.organization.id}/locations"
            }
          }
          json.should == represented
        end

        it 'is json' do
          response.content_type.should == 'application/json'
        end

        it 'returns a successful status code' do
          expect(response).to be_success
        end

        it "returns the location's street" do
          json["address"]["street"].should == "1800 Easton Drive"
        end
      end

      context 'with invalid data' do

        before :each do
          get "/api/locations/1"
        end

        it 'returns a not found error' do
          json["error"].should == "Not Found"
        end

        it 'returns a 404 status code' do
          response.status.should == 404
        end

        it 'is json' do
          response.content_type.should == 'application/json'
        end
      end

      context 'with nil fields' do

        before(:each) do
          @loc = create(:loc_with_nil_fields)
        end

        it 'does not return nil fields when visiting all locations' do
          get "api/locations"
          keys = json.first.keys
          ["faxes", "fees", "email"].each do |key|
            keys.should_not include(key)
          end
        end

        it 'does not return nil fields when visiting one location' do
          get "api/locations/#{@loc.id}"
          keys = json.keys
          ["faxes", "fees", "email"].each do |key|
            keys.should_not include(key)
          end
        end

        it 'does not return nil fields when searching for location' do
          get "api/search?keyword=belmont"
          keys = json.first.keys
          ["faxes", "fees", "email"].each do |key|
            keys.should_not include(key)
          end
        end
      end

      context "when farmers market" do
        before(:each) do
          fm = create(:farmers_market_loc)
          get "api/locations/#{fm.id}"
        end

        it 'includes products' do
          products = json["products"]
          products.should be_a Array
          ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"].each do |product|
            products.should include(product)
          end
        end

        it 'includes payments' do
          payments = json["payments"]
          payments.should be_a Array
          ["Credit", "WIC", "SFMNP", "SNAP"].each do |payment|
            payments.should include(payment)
          end
        end

        it 'includes market_match' do
          expect(json["market_match"]).to eq(true)
        end
      end
    end

    describe "PUT /api/locations/:id" do
      let(:valid_attributes) { { name: "test app",
                           main_url: "http://localhost:8080",
                           callback_url: "http://localhost:8080" } }
      before(:each) do
        @loc = create(:location)
        user = FactoryGirl.create(:user)
        api_application = user.api_applications.create! valid_attributes
        @token = api_application.api_token
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put "api/locations/#{@loc.id}", { :foo => "bar" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response).to be_success
        json.should_not include "foo"
      end

      it "allows setting whitelisted attributes" do
        put "api/locations/#{@loc.id}", { :kind => "human_services" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response).to be_success
        json["kind"].should == "Human Services"
      end

      it "validates the kind attribute" do
        put "api/locations/#{@loc.id}", { :kind => "Human Services" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Kind is not included in the list"
      end

      it "doesn't geocode when address hasn't changed" do
        @loc.coordinates = []
        @loc.save
        put "api/locations/#{@loc.id}", { :kind => "entertainment" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(@loc.coordinates).to eq([])
      end

      it "geocodes when address has changed" do
        address = {
          street: "1 davis drive", city: "belmont", state: "CA", zip: "94002"
        }
        coords = @loc.coordinates
        put "api/locations/#{@loc.id}", { :address => address },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(@loc.coordinates).to_not eq(coords)
      end
    end

  end
end