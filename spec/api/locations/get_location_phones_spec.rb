require 'rails_helper'

describe 'GET /locations/:location_id/phones' do
  context 'when location has phones' do
    before :all do
      @loc = create(:location)
      @first_phone = @loc.phones.create!(attributes_for(:phone))
    end

    before :each do
      get api_location_phones_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the id attribute in the serialization' do
      expect(json.first['id']).to eq(@first_phone.id)
    end

    it 'includes the number attribute in the serialization' do
      expect(json.first['number']).to eq(@first_phone.number)
    end

    it 'includes the department attribute in the serialization' do
      expect(json.first['department']).to eq(@first_phone.department)
    end

    it 'includes the extension attribute in the serialization' do
      expect(json.first['extension']).to eq(@first_phone.extension)
    end

    it 'includes the number_type attribute in the serialization' do
      expect(json.first['number_type']).to eq(@first_phone.number_type)
    end

    it 'includes the vanity_number attribute in the serialization' do
      expect(json.first['vanity_number']).to eq(@first_phone.vanity_number)
    end
  end

  context "when location doesn't have phones" do
    before :all do
      @loc = create(:location)
    end

    before :each do
      get api_location_phones_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
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
