require 'spec_helper'

describe "GET 'nearby'" do
  include DefaultUserAgent

  before :each do
    @loc = create(:location)
    create(:nearby_loc)
    create(:far_loc)
  end

  it 'is paginated' do
    get "api/locations/#{@loc.id}/nearby?page=2&per_page=1&radius=5"
    expect(json.first['name']).to eq('Belmont Farmers Market')
  end

  context 'with no radius' do
    it 'displays nearby locations within 0.5 miles' do
      get "api/locations/#{@loc.id}/nearby"
      expect(json).to eq([])
    end
  end

  context 'with valid radius' do
    it 'displays nearby locations within 2 miles' do
      get "api/locations/#{@loc.id}/nearby?radius=2"
      expect(json.length).to eq 1
      expect(json.first['name']).to eq('Library')
    end
  end

  context 'with invalid radius' do
    it "returns 'invalid radius' message" do
      get "api/locations/#{@loc.id}/nearby?radius=script"
      expect(json['error']).to eq('radius is invalid')
    end
  end

  context 'when the location has no coordinates' do
    it 'returns empty array' do
      no_address = create(:no_address)
      get "api/locations/#{no_address.id}/nearby"
      expect(json).to eq([])
    end
  end
end
