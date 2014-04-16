require 'spec_helper'

describe StatusController do

  describe "GET /.well-known/status" do

    it "returns success" do
      create(:loc_with_nil_fields)
      get "get_status"
      expect(response).to be_success
    end

    context "when DB can't find any Categories" do
      it "returns error" do
        create(:loc_with_nil_fields)
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "DB did not return location or category"
      end
    end

    context "when DB and search are up and running" do
      it "returns ok status" do
        create(:loc_with_nil_fields)
        category = create(:category)
        FactoryGirl.create(:service_with_nil_fields,
          :category_ids => ["#{category.id}"])
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "ok"
      end
    end

    context "when search returns no results" do
      it "returns search failure status" do
        create(:location)
        category = create(:category)
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "Search returned no results"
      end
    end


  end
end