require 'spec_helper'

describe Ohana::API do

  describe "GET Requests" do
    include DefaultUserAgent

    describe "GET /api/organizations" do
      it "returns an empty array when no organizations exist" do
        get "/api/organizations"
        expect(response).to be_success
        json.should == []
      end

      it "returns the correct number of existing organizations" do
        orgs = create_list(:organization, 2)
        get "/api/organizations"
        expect(response).to be_success
        expect(json.length).to eq(1)
      end

      it "supports pagination" do
        orgs = create_list(:organization, 2)
        get "/api/organizations?page=2"
        expect(response).to be_success
        expect(json.length).to eq(1)
        represented = [{
          "id" => "#{orgs.last.id}",
          "name" => "#{orgs.last.name}",
          "slugs" => orgs.last.slugs,
          "url" => "http://example.com/api/organizations/#{orgs.last.id}",
          "locations_url" => "http://example.com/api/organizations/#{orgs.last.id}/locations"
        }]
        json.should == represented
      end

      it "returns the correct info about the organizations" do
        create(:organization)
        get "/api/organizations"
        json.first["name"].should == "Parent Agency"
      end
    end

    describe "GET /api/organizations/:id" do
      context 'with valid data' do
        before :each do
          @org = create(:organization)
          get "/api/organizations/#{@org.id}"
        end

        it "returns a status by id" do
          represented = {
            "id" => "#{@org.id}",
            "name" => "#{@org.name}",
            "slugs" => @org.slugs,
            "url" => "http://example.com/api/organizations/#{@org.id}",
            "locations_url" => "http://example.com/api/organizations/#{@org.id}/locations"
          }
          json.should == represented
        end

        it 'is json' do
          response.content_type.should == 'application/json'
        end

        it 'returns a successful status code' do
          expect(response).to be_success
        end

        it "returns the organization's name" do
          json["name"].should == "Parent Agency"
        end
      end

      context 'with invalid data' do

        before :each do
          get "/api/organizations/1"
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
    end

    describe "PUT /api/organizations/:id" do
      let(:valid_attributes) { { name: "test app",
                           main_url: "http://localhost:8080",
                           callback_url: "http://localhost:8080" } }
      before(:each) do
        @org = create(:organization)
        @token = ENV["ADMIN_APP_TOKEN"]
      end

      it "requires name parameter" do
        put "api/organizations/#{@org.id}", { :foo => "bar" },
          { 'HTTP_X_API_TOKEN' => @token }
        @org.reload
        expect(response.status).to eq(400)
        expect(json["error"]).to eq("missing parameter: name")
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put "api/organizations/#{@org.id}", { :foo => "bar", :name => "test" },
          { 'HTTP_X_API_TOKEN' => @token }
        @org.reload
        expect(response).to be_success
        json.should_not include "foo"
        json["name"].should == "test"
      end

      it "allows setting whitelisted attributes" do
        put "api/organizations/#{@org.id}", { :name => "test org" },
          { 'HTTP_X_API_TOKEN' => @token }
        @org.reload
        expect(response).to be_success
        json["name"].should == "test org"
      end

    end

  end
end