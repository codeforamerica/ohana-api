require 'spec_helper'

describe StatusController do

  describe "GET /.well-known/status" do

    it "returns success" do
      get "get_status"
      expect(response).to be_success
    end

    context "when DB is empty" do
      it "returns DB failure error" do
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "DB returned blank location or category"
      end
    end

    context "when DB is not empty" do
      it "returns ok status" do
        location = create(:location)
        category = Category.create!(:name => "food")
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "ok"
      end
    end


  end
end