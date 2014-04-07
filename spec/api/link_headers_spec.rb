require 'spec_helper'

describe Ohana::API do

  describe "Link Headers" do
    include DefaultUserAgent

    context "when on page 1 of 2" do
      before(:each) do
        locs = create_list(:location, 2)
        get 'api/search?keyword=parent'
      end

      it "returns a Link header" do
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["Link"].should ==
        '<http://www.example.com/api/search?keyword=parent&page=2>; '+
        'rel="last", '+
        '<http://www.example.com/api/search?keyword=parent&page=2>; '+
        'rel="next"'
      end

      it "returns an X-Total-Count header" do
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["X-Total-Count"].should == "2"
      end

      it "returns an X-Total-Pages header" do
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["X-Total-Pages"].should == "2"
      end

      it "returns pagination headers" do
        headers["X-Current-Page"].should == "1"
        headers["X-Next-Page"].should == "2"
        headers["X-Previous-Page"].should be_nil
      end
    end

    context "when on page 2 of 2" do
      it "returns a Link header" do
        create_list(:location, 2)
        get 'api/search?keyword=parent&page=2'
        headers["Link"].should ==
        '<http://www.example.com/api/search?keyword=parent&page=1>; '+
        'rel="first", '+
        '<http://www.example.com/api/search?keyword=parent&page=1>; '+
        'rel="prev"'
        headers["X-Current-Page"].should == "2"
        headers["X-Next-Page"].should be_nil
        headers["X-Previous-Page"].should == "1"
      end
    end

    context "when on page 2 of 3" do
      it "returns a Link header" do
        original_create_list(:location, 3)
        get 'api/search?keyword=parent&page=2'
        headers["Link"].should ==
        '<http://www.example.com/api/search?keyword=parent&page=1>; '+
        'rel="first", '+
        '<http://www.example.com/api/search?keyword=parent&page=1>; '+
        'rel="prev", '+
        '<http://www.example.com/api/search?keyword=parent&page=3>; '+
        'rel="last", '+
        '<http://www.example.com/api/search?keyword=parent&page=3>; '+
        'rel="next"'
        headers["X-Current-Page"].should == "2"
        headers["X-Next-Page"].should == "3"
        headers["X-Previous-Page"].should == "1"
      end
    end

    context "when there is only one page of search results" do
      it "does not return a Link header" do
        create(:location)
        get 'api/search?keyword=parent'
        headers.keys.should_not include "Link"
      end
    end

    context "when there are no search results" do
      it "does not return a Link header" do
        create(:location)
        get 'api/search?keyword=foobar'
        headers.keys.should_not include "Link"
      end
    end

    context "when visiting a location" do
      it "does not return a Link header" do
        loc = create(:location)
        get "api/locations/#{loc.id}"
        headers.keys.should_not include "Link"
      end
    end

    context "when there is only one location" do
      it "does not return a Link header" do
        create(:location)
        get "api/locations"
        headers.keys.should_not include "Link"
      end
    end
  end
end