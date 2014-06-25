require 'rails_helper'

describe 'GET /locations/:location_id/phones' do
  context 'when location has phones' do
    before :each do
      loc = create(:location)
      @first_phone = loc.phones.
        create!(attributes_for(:phone_with_extra_whitespace))
      get api_endpoint(path: "/locations/#{loc.id}/phones")
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
    before :each do
      loc = create(:location)
      get api_endpoint(path: "/locations/#{loc.id}/phones")
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
