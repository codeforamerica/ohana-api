require 'rails_helper'

describe 'GET /locations/:location_id/services' do
  context 'when location has services' do
    before do
      create_service
      get api_location_services_url(@location, subdomain: ENV.fetch('API_SUBDOMAIN', nil))
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'serializes all service attributes and associations' do
      expect(json.first.keys).to eq(
        %w[id accepted_payments alternate_name audience description
           eligibility email fees funding_sources application_process
           interpretation_services keywords languages name required_documents
           service_areas status website wait_time updated_at categories
           contacts phones regular_schedules holiday_schedules]
      )
    end
  end

  context "when location doesn't have services" do
    before do
      loc = create(:location)
      get api_location_services_url(loc, subdomain: ENV.fetch('API_SUBDOMAIN', nil))
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
