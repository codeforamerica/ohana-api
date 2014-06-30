require 'rails_helper'

describe 'GET /locations/:location_id/services' do
  context 'when location has services' do
    before :all do
      @loc = create(:location)
      @first_service = @loc.services.
        create!(attributes_for(:service_with_extra_whitespace))
    end

    before :each do
      get api_location_services_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the id attribute in the serialization' do
      expect(json.first['id']).to eq(@first_service.id)
    end

    it 'includes the audience attribute in the serialization' do
      expect(json.first['audience']).to eq(@first_service.audience)
    end

    it 'includes the description attribute in the serialization' do
      expect(json.first['description']).to eq(@first_service.description)
    end

    it 'includes the eligibility attribute in the serialization' do
      expect(json.first['eligibility']).to eq(@first_service.eligibility)
    end

    it 'includes the fees attribute in the serialization' do
      expect(json.first['fees']).to eq(@first_service.fees)
    end

    it 'includes the funding_sources attribute in the serialization' do
      expect(json.first['funding_sources']).to eq([])
    end

    it 'includes the keywords attribute in the serialization' do
      expect(json.first['keywords']).to eq(@first_service.keywords)
    end

    it 'includes the how_to_apply attribute in the serialization' do
      expect(json.first['how_to_apply']).to eq(@first_service.how_to_apply)
    end

    it 'includes the name attribute in the serialization' do
      expect(json.first['name']).to eq(@first_service.name)
    end

    it 'includes the service_areas attribute in the serialization' do
      expect(json.first['service_areas']).to eq([])
    end

    it 'includes the short_desc attribute in the serialization' do
      expect(json.first['short_desc']).to eq(@first_service.short_desc)
    end

    it 'includes the urls attribute in the serialization' do
      expect(json.first['urls']).to eq([])
    end

    it 'includes the wait attribute in the serialization' do
      expect(json.first['wait']).to eq(@first_service.wait)
    end

    it 'includes the updated_at attribute in the serialization' do
      expect(json.first.keys).to include('updated_at')
    end
  end

  context "when location doesn't have services" do
    before :each do
      loc = create(:location)
      get api_location_services_url(loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
