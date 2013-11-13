require 'spec_helper'

describe Ohana::API do

  describe "PUT Requests for Services" do
    include DefaultUserAgent

    describe "PUT /api/services/:id/" do
      before(:each) do
        @service = create(:service)
        @token = ENV["ADMIN_APP_TOKEN"]
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put "api/services/#{@service.id}/",
          { :foo => "bar", :keywords => ["test"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response).to be_success
        json.should_not include "foo"
        json["keywords"].should == ["test"]
      end

      it "updates Elasticsearch index when service changes" do
        put "api/services/#{@service.id}/",
          { :service_areas => ["East Palo Alto", "San Mateo County"] },
          { 'HTTP_X_API_TOKEN' => @token }
        sleep 1 #Elasticsearch needs time to update the index
        get "/api/search?keyword=yoga"
        json.first["services"].first["service_areas"].should == ["East Palo Alto", "San Mateo County"]
      end

      it "validates service areas" do
        put "api/services/#{@service.id}/",
          { :service_areas => ["belmont", "Atherton"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response.status).to eq(400)
        json["message"].should include "At least one service area"
      end

      it "ensures keywords is an array" do
        put "api/services/#{@service.id}/",
          { :keywords => "health" },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response.status).to eq(400)
        json["message"].should include "Keywords must be an array"
      end

      it "ensures service_areas is an array" do
        put "api/services/#{@service.id}/",
          { :service_areas => "health" },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response.status).to eq(400)
        json["message"].should include "Service areas must be an array"
      end
    end

    describe "Update a service without a valid token" do
      it "doesn't allow updating a service witout a valid token" do
        service = create(:service)
        put "api/services/#{service.id}", { :name => "new name" },
          { 'HTTP_X_API_TOKEN' => "invalid_token" }
        service.reload
        expect(response.status).to eq(401)
      end
    end

  end
end