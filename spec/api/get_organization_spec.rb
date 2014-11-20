require 'rails_helper'

describe 'GET /organizations/:id' do
  context 'with valid id' do
    before :all do
      @org = create(:location).organization
    end

    before :each do
      get api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'includes the organization id' do
      expect(json['id']).to eq(@org.id)
    end

    it 'includes the name attribute' do
      expect(json['name']).to eq(@org.name)
    end

    it 'includes the slug attribute' do
      expect(json['slug']).to eq(@org.slug)
    end

    it 'includes the correct url attribute' do
      org_url = json['url']
      get org_url
      json = JSON.parse(response.body)
      expect(json['name']).to eq(@org.name)
    end

    it 'includes the correct locations_url attribute' do
      locations_url = json['locations_url']
      get locations_url
      json = JSON.parse(response.body)
      expect(json.first['organization']['name']).to eq(@org.name)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(200)
    end

    it 'includes the full representation' do
      expect(json.keys).to eq %w(id accreditations alternate_name
                                 date_incorporated description email
                                 funding_sources licenses name website
                                 slug url locations_url contacts phones)
    end
  end

  context 'with invalid id' do
    before :each do
      get api_organization_url(1, subdomain: ENV['API_SUBDOMAIN'])
    end

    it 'returns a status key equal to 404' do
      expect(json['status']).to eq(404)
    end

    it 'returns a helpful message' do
      expect(json['message']).
        to eq('The requested resource could not be found.')
    end

    it 'returns a 404 status code' do
      expect(response).to have_http_status(404)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end
  end

  context 'with nil fields' do
    before(:each) do
      @org = create(:organization)
    end

    it 'returns nil fields when visiting one organization' do
      get api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN'])
      expect(json.keys).to include('website')
    end
  end
end
