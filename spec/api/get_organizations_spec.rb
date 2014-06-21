require 'rails_helper'

describe 'GET /organizations' do
  it 'returns an empty array when no organizations exist' do
    get api_endpoint(path: '/organizations')
    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(json).to eq([])
  end

  context 'when more than one location exists' do
    before(:each) do
      create(:organization)
      create(:food_pantry)
    end

    it 'returns the correct number of existing organizations' do
      get api_endpoint(path: '/organizations')
      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
    end

    it 'sorts results by id ascending' do
      get api_endpoint(path: '/organizations')
      expect(json[1]['name']).to eq('Food Pantry')
    end

    it 'responds to pagination parameters' do
      get api_endpoint(path: '/organizations?page=2&per_page=1')
      expect(json.length).to eq(1)
    end
  end

  describe 'serializations' do
    before(:each) do
      location = create(:location)
      @org = location.organization
      get api_endpoint(path: '/organizations')
    end

    it 'returns the org id' do
      expect(json.first['id']).to eq(@org.id)
    end

    it 'returns the org name' do
      expect(json.first['name']).to eq(@org.name)
    end

    it 'returns the org slug' do
      expect(json.first['slug']).to eq(@org.slug)
    end

    it 'includes the correct url attribute' do
      org_url = json.first['url']

      get org_url
      json = JSON.parse(response.body)
      expect(json['name']).to eq(@org.name)
    end

    it 'returns the locations_url attribute' do
      expect(json.first['locations_url']).
        to eq("#{api_endpoint}/organizations/#{@org.slug}/locations")
    end

    context 'with nil fields' do
      before(:each) do
        @loc = create(:loc_with_nil_fields)
      end

      it 'does not return nil fields within Organization' do
        get api_endpoint(path: '/organizations')
        expect(json.first.keys).not_to include('urls')
      end
    end
  end
end
