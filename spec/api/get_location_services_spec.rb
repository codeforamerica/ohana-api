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

    it 'includes the accepted_payments attribute in the serialization' do
      expect(json.first['accepted_payments']).to eq(@first_service.accepted_payments)
    end

    it 'includes the alternate_name attribute in the serialization' do
      expect(json.first['alternate_name']).to eq(@first_service.alternate_name)
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

    it 'includes the email attribute in the serialization' do
      expect(json.first['email']).to eq(@first_service.email)
    end

    it 'includes the fees attribute in the serialization' do
      expect(json.first['fees']).to eq(@first_service.fees)
    end

    it 'includes the funding_sources attribute in the serialization' do
      expect(json.first['funding_sources']).to eq(['County'])
    end

    it 'includes the how_to_apply attribute in the serialization' do
      expect(json.first['how_to_apply']).to eq(@first_service.how_to_apply)
    end

    it 'includes the keywords attribute in the serialization' do
      expect(json.first['keywords']).to eq(@first_service.keywords)
    end

    it 'includes the languages attribute in the serialization' do
      expect(json.first['languages']).to eq(@first_service.languages)
    end

    it 'includes the name attribute in the serialization' do
      expect(json.first['name']).to eq(@first_service.name)
    end

    it 'includes the required_documents attribute in the serialization' do
      expect(json.first['required_documents']).to eq(@first_service.required_documents)
    end

    it 'includes the service_areas attribute in the serialization' do
      expect(json.first['service_areas']).to eq(['Belmont'])
    end

    it 'includes the status attribute in the serialization' do
      expect(json.first['status']).to eq(@first_service.status)
    end

    it 'includes the website attribute in the serialization' do
      expect(json.first['website']).to eq('http://www.monfresh.com')
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
