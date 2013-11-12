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

      it "doesn't include test data" do
        create(:location)
        create(:far_loc)
        get "/api/locations"
        headers["X-Total-Count"].should == "1"
        expect(json.first["name"]).to eq "VRS Services"
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
            "short_desc" => "short description",
            "slugs" => ["vrs-services"],
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
              "slugs" => @location.organization.slugs,
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
          puts json
          expect(json["market_match"]).to eq(true)
        end
      end
    end

    describe "Update a location (PUT /api/locations/:id)" do
      before(:each) do
        @loc = create(:location)
        @token = ENV["ADMIN_APP_TOKEN"]
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

      it "validates the accessibility attribute" do
        put "api/locations/#{@loc.id}", { :accessibility => "Human Services" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Accessibility is invalid"
      end

      it "validates phone number" do
        put "api/locations/#{@loc.id}", { :phones => [{ number: "703" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "703 is not a valid US phone number"
      end

      it "validates fax number" do
        put "api/locations/#{@loc.id}", { :faxes => [{ number: "703" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Please enter a valid US fax number"
      end

      it "validates fax number is a hash" do
        put "api/locations/#{@loc.id}", { :faxes => ["703"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].
          should include "Fax must be a hash"
      end

      it "validates fax number is an array" do
        put "api/locations/#{@loc.id}", { :faxes => "703" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].
          should include "Fax must be an array"
      end

      it "allows empty fax number" do
        put "api/locations/#{@loc.id}", { :faxes => nil },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(200)
      end

      it "strips out empty emails from array" do
        put "api/locations/#{@loc.id}", { :emails => [""] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(200)
      end

      it "validates contact phone" do
        put "api/locations/#{@loc.id}",
          { :contacts => [{ name: "foo", title: "cfo", phone: "703" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Phone 703 is not a valid US phone number"
      end

      it "validates contact fax" do
        put "api/locations/#{@loc.id}",
          { :contacts => [{ name: "foo", title: "cfo", fax: "703" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Fax 703 is not a valid US fax number"
      end

      it "validates contact email" do
        put "api/locations/#{@loc.id}",
          { :contacts => [{ name: "foo", title: "cfo", email: "703" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Email 703 is not a valid email"
      end

      it "requires contact name" do
        put "api/locations/#{@loc.id}",
          { :contacts => [{ title: "cfo" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Name can't be blank for Contact"
      end

      it "requires contact title" do
        put "api/locations/#{@loc.id}",
          { :contacts => [{ name: "cfo" }] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Title can't be blank for Contact"
      end

      it "requires description" do
        put "api/locations/#{@loc.id}",
          { :description => "" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Description can't be blank"
      end

      it "requires short description" do
        put "api/locations/#{@loc.id}",
          { :short_desc => "" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Short desc can't be blank"
      end

      it "limits short description to 200 characters" do
        put "api/locations/#{@loc.id}",
          { :short_desc => "A 6 month residential co-ed treatment program
            designed to provide homeless veterans with the skills necessary
            to function self-sufficiently in society. Residents attend schools
            all day" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "too long (maximum is 200 characters)"
      end

      it "requires location name" do
        put "api/locations/#{@loc.id}",
          { :name => "" },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Name can't be blank"
      end

      it "validates location email" do
        put "api/locations/#{@loc.id}",
          { :emails => ["703", "mo@cfa.org"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "703 is not a valid email"
      end

      it "validates location URLs" do
        put "api/locations/#{@loc.id}",
          { :urls => ["badurl"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Urls badurl is not a valid URL"
      end

      it "validates location address state" do
        put "api/locations/#{@loc.id}",
          { :address => {:state => "C" } },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "State is too short (minimum is 2 characters)"
      end

      it "validates location address zip" do
        put "api/locations/#{@loc.id}",
          { :address => {:zip => "1234" } },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Zip 1234 is not a valid ZIP code"
      end

      it "requires location address street" do
        put "api/locations/#{@loc.id}",
          { :address => {
              street: "", city: "utopia", state: "CA", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Street can't be blank"
      end

      it "requires location address state" do
        put "api/locations/#{@loc.id}",
          { :address => {
              street: "boo", city: "utopia", state: "", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "State can't be blank"
      end

      it "requires location address city" do
        put "api/locations/#{@loc.id}",
          { :address => {
              street: "funu", city: "", state: "CA", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "City can't be blank"
      end

      it "requires location address zip" do
        put "api/locations/#{@loc.id}",
          { :address => {
              street: "jam", city: "utopia", state: "CA", zip: "" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Zip can't be blank"
      end

      it "validates location mail address state" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {:state => "C" } },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "State is too short (minimum is 2 characters)"
      end

      it "validates location mail address zip" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {:zip => "1234" } },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Zip 1234 is not a valid ZIP code"
      end

      it "requires location mail_address street" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {
              street: "", city: "utopia", state: "CA", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Street can't be blank"
      end

      it "requires location mail_address state" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {
              street: "boo", city: "utopia", state: "", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "State can't be blank"
      end

      it "requires location mail_address city" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {
              street: "funu", city: "", state: "CA", zip: "12345" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "City can't be blank"
      end

      it "requires location mail_address zip" do
        put "api/locations/#{@loc.id}",
          { :mail_address => {
              street: "jam", city: "utopia", state: "CA", zip: "" }
          },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "Zip can't be blank"
      end

      it "rejects location with neither address nor mail address" do
        put "api/locations/#{@loc.id}", { :address => nil },
          { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(response.status).to eq(400)
        json["message"].should include "A location must have at least one address type."
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

      it "resets coordinates when address is removed" do
        put "api/locations/#{@loc.id}",
          {
            :address => nil,
            :mail_address => {
              street: "1 davis drive", city: "belmont",
              state: "CA", zip: "94002"
            }
          }, { 'HTTP_X_API_TOKEN' => @token }
        @loc.reload
        expect(@loc.coordinates).to be_nil
      end

      it "updates the Elasticsearch index when location changes" do
        put "api/locations/#{@loc.id}",
          { :name => "changeme" },
          { 'HTTP_X_API_TOKEN' => @token }
        sleep 1 # Elasticsearch needs time to update the index
        get "/api/search?keyword=changeme"
        json.first["name"].should == "changeme"
      end
    end

  end
end