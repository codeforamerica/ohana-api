require 'rails_helper'

describe 'Pagination Headers' do
  before(:each) do
    @prefix = api_endpoint
  end

  context 'when on page 1 of 2' do
    before(:each) do
      create_list(:location, 2)
      get api_endpoint(path: '/search?keyword=parent&per_page=1')
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}/search?keyword=parent&page=2" \
        "&per_page=1>; rel=\"last\", " \
        "<#{@prefix}/search?keyword=parent&page=2" \
        "&per_page=1>; rel=\"next\""
      )
    end

    it 'returns an X-Total-Count header' do
      expect(response.status).to eq 200
      expect(json.length).to eq(1)
      expect(headers['X-Total-Count']).to eq('2')
    end

    it 'returns an X-Total-Pages header' do
      expect(response.status).to eq 200
      expect(json.length).to eq(1)
      expect(headers['X-Total-Pages']).to eq('2')
    end

    it 'returns pagination headers' do
      expect(headers['X-Current-Page']).to eq '1'
      expect(headers['X-Next-Page']).to eq '2'
      expect(headers['X-Previous-Page']).to be_nil
    end
  end

  context 'when on page 2 of 2' do
    before(:each) do
      create_list(:location, 2)
      get api_endpoint(path: '/search?keyword=parent&page=2&per_page=1')
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}/search?keyword=parent&page=1" \
        "&per_page=1>; rel=\"first\", " \
        "<#{@prefix}/search?keyword=parent&page=1" \
        "&per_page=1>; rel=\"prev\""
      )
    end

    it 'returns pagination headers' do
      expect(headers['X-Current-Page']).to eq '2'
      expect(headers['X-Next-Page']).to be_nil
      expect(headers['X-Previous-Page']).to eq('1')
    end
  end

  context 'when on page 2 of 3' do
    before(:each) do
      original_create_list(:location, 3)
      get api_endpoint(path: '/search?keyword=parent&page=2&per_page=1')
    end

    it 'returns a Link header' do
      expect(headers['Link']).to eq(
        "<#{@prefix}/search?keyword=parent&page=1" \
        "&per_page=1>; rel=\"first\", " \
        "<#{@prefix}/search?keyword=parent&page=1" \
        "&per_page=1>; rel=\"prev\", " \
        "<#{@prefix}/search?keyword=parent&page=3" \
        "&per_page=1>; rel=\"last\", " \
        "<#{@prefix}/search?keyword=parent&page=3" \
        "&per_page=1>; rel=\"next\""
      )
    end

    it 'returns pagination headers' do
      expect(headers['X-Current-Page']).to eq '2'
      expect(headers['X-Next-Page']).to eq '3'
      expect(headers['X-Previous-Page']).to eq '1'
    end
  end

  context 'when on page higher than max' do
    before(:each) do
      original_create_list(:location, 3)
      get api_endpoint(path: '/search?keyword=vrs&page=3')
    end

    it 'sets previous page to last page with results' do
      expect(headers['Link']).to eq(
        "<#{@prefix}/search?keyword=vrs&page=1>; rel=\"first\", " \
        "<#{@prefix}/search?keyword=vrs&page=1>; rel=\"prev\", " \
        "<#{@prefix}/search?keyword=vrs&page=1>; rel=\"last\""
      )
    end

    it 'returns pagination headers' do
      expect(headers.keys).not_to include 'X-Current-Page'
      expect(headers.keys).not_to include 'X-Next-Page'
      expect(headers['X-Previous-Page']).to eq '1'
      expect(headers['X-Total-Pages']).to eq('1')
    end
  end

  context 'when there is only one page of search results' do
    it 'does not return a Link header' do
      create(:location)
      get api_endpoint(path: '/search?keyword=parent')
      expect(headers.keys).not_to include 'Link'
    end
  end

  context 'when there are no search results' do
    it 'returns one rel=last link with page=0' do
      create(:location)
      get api_endpoint(path: '/search?keyword=foo')
      expect(headers['Link']).
        to eq("<#{@prefix}/search?keyword=foo&page=0>; rel=\"last\"")
      expect(headers['X-Total-Count']).to eq('0')
    end
  end

  context 'when visiting a location' do
    it 'does not return a Link header' do
      loc = create(:location)
      get api_endpoint(path: "/locations/#{loc.id}")
      expect(headers.keys).not_to include 'Link'
    end
  end

  context 'when there is only one location' do
    it 'does not return a Link header' do
      create(:location)
      get api_endpoint(path: '/locations')
      expect(headers.keys).not_to include 'Link'
    end
  end
end
