require 'rails_helper'

describe "GET 'nearby'" do
  before :each do
    @loc = create(:location)
    create(:nearby_loc)
    create(:far_loc)
  end

  it 'is paginated' do
    get api_location_nearby_url(@loc, page: 2, per_page: 1, radius: 5, subdomain: ENV['API_SUBDOMAIN'])
    expect(json.first['name']).to eq('Belmont Farmers Market')
  end

  context 'with no radius' do
    it 'displays nearby locations within 0.5 miles' do
      get api_location_nearby_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json).to eq([])
    end
  end

  context 'with valid radius' do
    it 'displays nearby locations within 2 miles' do
      get api_location_nearby_url(@loc, radius: 2, subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 1
      expect(json.first['name']).to eq('Library')
    end
  end

  context 'with invalid radius' do
    it 'returns an invalid radius message' do
      get api_location_nearby_url(@loc, radius: 'script', subdomain: ENV['API_SUBDOMAIN'])
      expect(json['description']).
        to eq('Radius must be a Float between 0.1 and 50.')
      expect(response).to have_http_status(400)
    end
  end

  context 'when the location has no coordinates' do
    it 'returns empty array' do
      no_address = create(:no_address)
      get api_location_nearby_url(no_address, subdomain: ENV['API_SUBDOMAIN'])
      expect(json).to eq([])
    end
  end
end
