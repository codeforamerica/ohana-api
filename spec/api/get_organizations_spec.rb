require 'rails_helper'

describe 'GET /organizations' do
  it 'returns an empty array when no organizations exist' do
    get api_organizations_url(subdomain: ENV['API_SUBDOMAIN'])
    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(json).to eq([])
  end

  context 'when more than one location exists' do
    before(:all) do
      create(:organization)
      create(:food_pantry)
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns the correct number of existing organizations' do
      get api_organizations_url(subdomain: ENV['API_SUBDOMAIN'])
      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
    end

    it 'sorts results by id descending' do
      get api_organizations_url(subdomain: ENV['API_SUBDOMAIN'])
      expect(json.first['name']).to eq('Food Pantry')
    end

    it 'responds to pagination parameters' do
      get api_organizations_url(page: 2, per_page: 1, subdomain: ENV['API_SUBDOMAIN'])
      expect(json.length).to eq(1)
    end
  end

  describe 'serializations' do
    before(:all) do
      location = create(:location)
      @org = location.organization
    end

    before(:each) do
      @org.reload
      get api_organizations_url(subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
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

    it 'includes the correct locations_url attribute' do
      locations_url = json.first['locations_url']

      get locations_url
      json = JSON.parse(response.body)
      expect(json.first['organization']['name']).to eq(@org.name)
    end

    context 'with nil fields' do
      before(:each) do
        @loc = create(:loc_with_nil_fields)
      end

      it 'returns nil fields within Organization' do
        get api_organizations_url(subdomain: ENV['API_SUBDOMAIN'])
        expect(json.first.keys).to include('website')
      end
    end
  end
end
