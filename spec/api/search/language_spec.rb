require 'rails_helper'

describe "GET 'search'" do
  context 'with language parameter' do
    before(:each) do
      create(:nearby_loc)
      create(:farmers_market_loc)
    end

    it 'finds matching locations when language is a String' do
      get api_search_index_url(
        language: 'Arabic',
        subdomain: ENV['API_SUBDOMAIN']
      )
      expect(json.length).to eq(1)
      expect(json.first['name']).to eq('Library')
    end

    it 'finds matching locations when language is an Array' do
      get 'api/search?language[]=Spanish&language[]=French'
      expect(json.length).to eq(2)
    end

    it 'finds matching locations when category parameter is present' do
      get 'api/search?language=Spanish&category=Food'
      expect(json.length).to eq(0)
    end
  end
end
