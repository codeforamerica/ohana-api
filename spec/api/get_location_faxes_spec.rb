require 'rails_helper'

describe 'GET /locations/:location_id/faxes' do
  context 'when location has faxes' do
    before :all do
      @loc = create(:location)
      @first_fax = @loc.faxes.create!(attributes_for(:fax))
    end

    before :each do
      get api_location_faxes_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the id attribute in the serialization' do
      expect(json.first['id']).to eq(@first_fax.id)
    end

    it 'includes the number attribute in the serialization' do
      expect(json.first['number']).to eq(@first_fax.number)
    end

    it 'includes the department attribute in the serialization' do
      expect(json.first['department']).to eq(@first_fax.department)
    end
  end

  context "when location doesn't have faxes" do
    before :all do
      @loc = create(:location)
    end

    before :each do
      get api_location_faxes_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
