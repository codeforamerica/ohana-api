require 'rails_helper'

describe "GET 'search'" do
  context 'with service_area parameter' do
    before(:each) do
      create(:nearby_loc)
      create(:farmers_market_loc)
      create_service
      @service.service_areas = ['Atherton']
      @service.save
    end

    it 'only returns locations with matching service areas' do
      get api_search_index_url(service_area: 'Atherton', subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 1
    end

    it 'does not return locations when no matching service areas exist' do
      get api_search_index_url(service_area: 'Belmont', subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 0
    end

    it 'allows combining service_area with other parameters' do
      get api_search_index_url(
        service_area: 'Atherton',
        org_name: 'Parent Agency',
        keyword: 'jobs',
        location: 'Burlingame',
        subdomain: ENV['API_SUBDOMAIN']
      )
      expect(json.length).to eq 1
    end
  end
end
