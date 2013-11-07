require 'spec_helper'

describe Ohana::API do

  describe "PUT Requests for Services" do
    include DefaultUserAgent

    describe "PUT /api/services/:id/keywords" do
      before(:each) do
        @service = create(:service)
        @token = ENV["ADMIN_APP_TOKEN"]
      end

      it "requires keywords parameter" do
        put "api/services/#{@service.id}/keywords", { :foo => "bar" },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response.status).to eq(400)
        expect(json["error"]).to eq("missing parameter: keywords")
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put "api/services/#{@service.id}/keywords",
          { :foo => "bar", :keywords => ["test"] },
          { 'HTTP_X_API_TOKEN' => @token }
        @service.reload
        expect(response).to be_success
        json.should_not include "foo"
        json["keywords"].should == ["test"]
      end

      it "updates Elasticsearch index when service changes" do
        put "api/services/#{@service.id}/keywords",
          { :keywords => ["service change"] },
          { 'HTTP_X_API_TOKEN' => @token }
        sleep 1 #Elasticsearch needs time to update the index
        get "/api/search?keyword=yoga"
        json.first["services"].first["keywords"].should == ["service change"]
      end

    end

  end
end