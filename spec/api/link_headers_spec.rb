require 'spec_helper'

describe Ohana::API do

  describe 'Link Headers' do
    include DefaultUserAgent

    context 'when on page 1 of 2' do
      before(:each) do
        create_list(:location, 2)
        get 'api/search?keyword=parent&per_page=1'
      end

      it 'returns a Link header' do
        expect(response.status).to eq 200
        expect(json.length).to eq(1)
        expect(headers['Link']).to eq(
          '<http://www.example.com/api/search?keyword=parent&page=2' \
          '&per_page=1>; rel="last", ' \
          '<http://www.example.com/api/search?keyword=parent&page=2' \
          '&per_page=1>; rel="next"'
        )
      end

      it 'returns an X-Total-Count header' do
        expect(response.status).to eq 200
        expect(json.length).to eq(1)
        headers['X-Total-Count'].should == '2'
      end

      it 'returns an X-Total-Pages header' do
        expect(response.status).to eq 200
        expect(json.length).to eq(1)
        headers['X-Total-Pages'].should == '2'
      end

      it 'returns pagination headers' do
        expect(headers['X-Current-Page']).to eq '1'
        expect(headers['X-Next-Page']).to eq '2'
        headers['X-Previous-Page'].should be_nil
      end
    end

    context 'when on page 2 of 2' do
      it 'returns a Link header' do
        create_list(:location, 2)
        get 'api/search?keyword=parent&page=2&per_page=1'
        expect(headers['Link']).to eq(
          '<http://www.example.com/api/search?keyword=parent&page=1' \
          '&per_page=1>; rel="first", ' \
          '<http://www.example.com/api/search?keyword=parent&page=1' \
          '&per_page=1>; rel="prev"'
        )
        expect(headers['X-Current-Page']).to eq '2'
        headers['X-Next-Page'].should be_nil
        headers['X-Previous-Page'].should == '1'
      end
    end

    context 'when on page 2 of 3' do
      it 'returns a Link header' do
        original_create_list(:location, 3)
        get 'api/search?keyword=parent&page=2&per_page=1'
        expect(headers['Link']).to eq(
          '<http://www.example.com/api/search?keyword=parent&page=1' \
          '&per_page=1>; rel="first", ' \
          '<http://www.example.com/api/search?keyword=parent&page=1' \
          '&per_page=1>; rel="prev", ' \
          '<http://www.example.com/api/search?keyword=parent&page=3' \
          '&per_page=1>; rel="last", ' \
          '<http://www.example.com/api/search?keyword=parent&page=3' \
          '&per_page=1>; rel="next"'
        )
        expect(headers['X-Current-Page']).to eq '2'
        expect(headers['X-Next-Page']).to eq '3'
        expect(headers['X-Previous-Page']).to eq '1'
      end
    end

    context 'when on page higher than max' do
      it 'sets previous page to last page with results' do
        original_create_list(:location, 3)
        get 'api/search?keyword=vrs&page=3'
        expect(headers['Link']).to eq(
          '<http://www.example.com/api/search?keyword=vrs&page=1' \
          '&per_page=30>; rel="first", ' \
          '<http://www.example.com/api/search?keyword=vrs&page=1' \
          '&per_page=30>; rel="prev", ' \
          '<http://www.example.com/api/search?keyword=vrs&page=1' \
          '&per_page=30>; rel="last"'
        )
        headers.keys.should_not include 'X-Current-Page'
        headers.keys.should_not include 'X-Next-Page'
        expect(headers['X-Previous-Page']).to eq '1'
        headers['X-Total-Pages'].should == '1'
      end
    end

    context 'when there is only one page of search results' do
      it 'does not return a Link header' do
        create(:location)
        get 'api/search?keyword=parent'
        headers.keys.should_not include 'Link'
      end
    end

    context 'when there are no search results' do
      it 'returns one rel=last link with page=0' do
        create(:location)
        get 'api/search?keyword=foo'
        expect(headers['Link']).to eq(
          '<http://www.example.com/api/search?keyword=foo&page=0' \
          '&per_page=30>; rel="last"'
        )
        headers['X-Total-Count'].should == '0'
      end
    end

    context 'when visiting a location' do
      it 'does not return a Link header' do
        loc = create(:location)
        get "api/locations/#{loc.id}"
        headers.keys.should_not include 'Link'
      end
    end

    context 'when there is only one location' do
      it 'does not return a Link header' do
        create(:location)
        get 'api/locations'
        headers.keys.should_not include 'Link'
      end
    end
  end
end
