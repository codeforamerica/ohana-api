require 'rails_helper'

describe 'GET /locations/:location_id/contacts' do
  context 'when location has contacts' do
    before :all do
      @loc = create(:location)
      @first_contact = @loc.contacts.
        create!(attributes_for(:contact_with_extra_whitespace))
    end

    before :each do
      get api_location_contacts_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the id attribute in the serialization' do
      expect(json.first['id']).to eq(@first_contact.id)
    end

    it 'includes the name attribute in the serialization' do
      expect(json.first['name']).to eq(@first_contact.name)
    end

    it 'includes the title attribute in the serialization' do
      expect(json.first['title']).to eq(@first_contact.title)
    end

    it 'includes the email attribute in the serialization' do
      expect(json.first['email']).to eq(@first_contact.email)
    end

    it 'includes the fax attribute in the serialization' do
      expect(json.first['fax']).to eq(@first_contact.fax)
    end

    it 'includes the phone attribute in the serialization' do
      expect(json.first['phone']).to eq(@first_contact.phone)
    end

    it 'includes the extension attribute in the serialization' do
      expect(json.first['extension']).to eq(@first_contact.extension)
    end
  end

  context "when location doesn't have contacts" do
    before :all do
      @loc = create(:location)
    end

    before :each do
      get api_location_contacts_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
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
