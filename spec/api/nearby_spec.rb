require 'spec_helper'

describe "GET 'nearby'" do
  include DefaultUserAgent

  before :each do
    @loc = create(:location)
    nearby = create(:nearby_loc)
    far = create(:far_loc)
  end

  it "is paginated" do
    get "api/locations/#{@loc.id}/nearby?page=2"
    json.first["name"].should == "Belmont Farmers Market"
  end

  context 'with no radius' do
    it "displays nearby locations within 5 miles" do
      get "api/locations/#{@loc.id}/nearby"
      json.first["name"].should == "Library"
    end
  end

  context 'with valid radius' do
    it "displays nearby locations within 2 mile2" do
      get "api/locations/#{@loc.id}/nearby?radius=2"
      json.length.should == 1
      json.first["name"].should == "Library"
    end
  end

  context 'with invalid radius' do
    it "returns 'invalid radius' message" do
      get "api/locations/#{@loc.id}/nearby?radius=script"
      json["error"].should == "invalid parameter: radius"
    end
  end

  context 'when the location has no coordinates' do
    it "returns empty array" do
      no_address = create(:no_address)
      get "api/locations/#{no_address.id}/nearby"
      json.should == []
    end
  end
end