require 'spec_helper'

describe Ohana::API do

  describe "GET Requests" do
    include DefaultUserAgent

    describe "GET /api/locations" do
      it "returns an empty array when no locations exist" do
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

      it "supports pagination" do
        locs = create_list(:location, 2)
        get "/api/locations?page=2"
        expect(response).to be_success
        expect(json.length).to eq(1)
        represented = [{
          "id" => "#{locs.last.id}",
            "accessibility"=>[],
            "coordinates"=>locs.last.coordinates,
            "description"=>locs.last.description,
            "name"=>locs.last.name,
            "phones"=>[{
              "number"=>"650 851-1210",
              "department"=>"Information",
              "phone_hours"=>"(Monday-Friday, 9-12, 1-5)"
            }],
            "address"=>{
              "street"=>locs.last.address.street,
              "city"=>locs.last.address.city,
              "state"=>locs.last.address.state,
              "zip"=>locs.last.address.zip
            },
            "contacts"=>[],
            "updated_at"=> locs.last.updated_at.strftime("%Y-%m-%dT%H:%M:%S%:z"),
            "organization"=>{
              "id"=>"#{locs.last.organization.id}",
              "name"=>"Parent Agency",
              "url" => "http://example.com/api/organizations/#{locs.last.organization.id}",
              "locations_url" =>"http://example.com/api/organizations/#{locs.last.organization.id}/locations"
            },
            "services"=>[],
            "url" => "http://example.com/api/locations/#{locs.last.id}",
            "other_locations" => []
        }]
        json.should == represented
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
            "accessibility" => [],
            "coordinates" => @location.coordinates,
            "description" => @location.description,
            "name" => @location.name,
            "phones" => [{
              "number" => "650 851-1210",
              "department" => "Information",
              "phone_hours" => "(Monday-Friday, 9-12, 1-5)"
            }],
            "address" => {
              "street" => @location.address.street,
              "city" => @location.address.city,
              "state" => @location.address.state,
              "zip" => @location.address.zip
            },
            "contacts" => [],
            "updated_at" => @location.updated_at.strftime("%Y-%m-%dT%H:%M:%S%:z"),
            "organization" => {
              "id" => "#{@location.organization.id}",
              "name"=> "Parent Agency",
              "url" => "http://example.com/api/organizations/#{@location.organization.id}",
              "locations_url" => "http://example.com/api/organizations/#{@location.organization.id}/locations"
            },
            "services" => [{
              "description" => @location.services.first.description,
              "keywords" => @location.services.first.keywords,
              "name" => @location.services.first.name
            }],
            "url" => "http://example.com/api/locations/#{@location.id}",
            "other_locations" => []
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
    end

  end
end