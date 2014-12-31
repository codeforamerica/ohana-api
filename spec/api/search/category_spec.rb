require 'rails_helper'

describe "GET 'search'" do
  context 'with category parameter' do
    before(:each) do
      nearby = create(:nearby_loc)
      create(:farmers_market_loc)

      jobs = create(:jobs)
      health = create(:health)

      create_service
      @service.category_ids = [jobs.id]
      @service.save

      nearby.services.create!(attributes_for(:service))
      service = nearby.services.first
      service.category_ids = [health.id]
      service.save
    end

    it 'only returns locations whose category name matches the query' do
      get api_search_index_url(category: 'Jobs', subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 1
      expect(json.first['name']).to eq('VRS Services')
    end

    it 'only finds exact spelling matches for the category' do
      get api_search_index_url(category: 'jobs', subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 0
    end

    it 'finds locations that match either category name' do
      get 'api/search?category[]=Jobs&category[]=Health'
      expect(json.length).to eq 2
    end
  end

  context 'with category and keyword parameters' do
    before(:each) do
      loc1 = create(:nearby_loc)
      loc2 = create(:farmers_market_loc)
      loc3 = create(:location)

      cat = create(:jobs)
      [loc1, loc2, loc3].each do |loc|
        loc.services.create!(attributes_for(:service))
        service = loc.services.first
        service.category_ids = [cat.id]
        service.save
      end
    end

    it 'returns unique locations when keyword matches the query' do
      get api_search_index_url(category: 'Jobs', keyword: 'jobs', subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq 3
    end
  end
end
