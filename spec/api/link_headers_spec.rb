require 'spec_helper'

describe Ohana::API do

  describe "Link Headers" do
    include DefaultUserAgent

    context "when on page 1 of 2" do
      it "returns a Link header" do
        orgs = create_list(:location, 2)
        get 'api/search?keyword=parent'
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["Link"].should ==
        '<http://www.example.com/api/search?keyword=parent&page=2>; '+
        'rel="last", '+
        '<http://www.example.com/api/search?keyword=parent&page=2>; '+
        'rel="next"'
      end

      it "returns an X-Total header" do
        orgs = create_list(:location, 2)
        get 'api/search?keyword=parent'
        response.status.should == 200
        expect(json.length).to eq(1)
        headers["X-Total"].should == "2"
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
      end
    end
  end
end