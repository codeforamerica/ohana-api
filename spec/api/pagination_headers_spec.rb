require 'rails_helper'

describe 'Pagination Headers' do
  before(:each) do
    @prefix = api_search_index_url(subdomain: ENV['API_SUBDOMAIN'])
  end

  context 'when on page 1 of 2' do
    before(:all) do
      create(:location)
      create(:nearby_loc)
    end

    before(:each) do
      get api_search_index_url(
        keyword: 'jobs', per_page: 1, subdomain: ENV['API_SUBDOMAIN']
      )
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}?keyword=jobs&page=2" \
        "&per_page=1>; rel=\"last\", " \
        "<#{@prefix}?keyword=jobs&page=2" \
        "&per_page=1>; rel=\"next\""
      )
    end

    it 'returns an X-Total-Count header' do
      expect(response.status).to eq 200
      expect(json.length).to eq(1)
      expect(headers['X-Total-Count']).to eq('2')
    end
  end

  context 'when on page 2 of 2' do
    before(:all) do
      create(:location)
      create(:nearby_loc)
    end

    before(:each) do
      get api_search_index_url(
        keyword: 'jobs', page: 2, per_page: 1, subdomain: ENV['API_SUBDOMAIN']
      )
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}?keyword=jobs&page=1" \
        "&per_page=1>; rel=\"first\", " \
        "<#{@prefix}?keyword=jobs&page=1" \
        "&per_page=1>; rel=\"prev\""
      )
    end
  end

  context 'when on page 2 of 3' do
    before(:all) do
      create(:location)
      create(:nearby_loc)
      create(:farmers_market_loc)
    end

    before(:each) do
      get api_search_index_url(
        keyword: 'jobs', page: 2, per_page: 1, subdomain: ENV['API_SUBDOMAIN']
      )
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}?keyword=jobs&page=1" \
        "&per_page=1>; rel=\"first\", " \
        "<#{@prefix}?keyword=jobs&page=1" \
        "&per_page=1>; rel=\"prev\", " \
        "<#{@prefix}?keyword=jobs&page=3" \
        "&per_page=1>; rel=\"last\", " \
        "<#{@prefix}?keyword=jobs&page=3" \
        "&per_page=1>; rel=\"next\""
      )
    end
  end

  context 'when on page higher than max' do
    before(:all) do
      create(:location)
      create(:nearby_loc)
      create(:far_loc)
    end

    before(:each) do
      get api_search_index_url(
        keyword: 'vrs', page: 3, subdomain: ENV['API_SUBDOMAIN']
      )
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'sets previous page to last page with results' do
      expect(headers['Link']).to eq(
        "<#{@prefix}?keyword=vrs&page=1>; rel=\"first\", " \
        "<#{@prefix}?keyword=vrs&page=1>; rel=\"prev\", " \
        "<#{@prefix}?keyword=vrs&page=1>; rel=\"last\""
      )
    end
  end

  context 'when there is only one page of search results' do
    it 'does not return a Link header' do
      create(:location)
      get api_search_index_url(
        keyword: 'jobs', subdomain: ENV['API_SUBDOMAIN']
      )
      expect(headers.keys).not_to include 'Link'
    end
  end

  context 'when there are no search results' do
    it 'returns one rel=last link with page=0' do
      create(:location)
      get api_search_index_url(keyword: 'foo', subdomain: ENV['API_SUBDOMAIN'])
      expect(headers['Link']).
        to eq("<#{@prefix}?keyword=foo&page=0>; rel=\"last\"")
      expect(headers['X-Total-Count']).to eq('0')
    end
  end

  context 'when visiting a location' do
    it 'does not return a Link header' do
      loc = create(:location)
      get api_location_url(loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(headers.keys).not_to include 'Link'
    end
  end

  context 'when there is only one location' do
    it 'does not return a Link header' do
      create(:location)
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      expect(headers.keys).not_to include 'Link'
    end
  end
end
