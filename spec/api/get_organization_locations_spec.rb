require 'rails_helper'

describe 'GET /organizations/:organization_id/locations' do
  context 'when organization has locations' do
    before :all do
      @org = create(:organization)
      attrs = {
        accessibility: %w(restroom),
        admin_emails: %w(foo@bar.com),
        description: 'testing 1 2 3',
        emails: %w(foo@bar.com),
        hours: 'Monday-Friday 10am-6pm',
        languages: %w(french, arabic),
        latitude: 37.583939,
        longitude: -122.3715745,
        name: 'new location',
        short_desc: 'short_desc',
        transportation: 'BART stops 1 block away',
        urls: %w(http://monfresh.com),
        address_attributes: attributes_for(:address)
      }
      @location = @org.locations.create!(attrs)
      @location.contacts.create!(attributes_for(:contact))
      @location.phones.create!(attributes_for(:phone))
      @location.contacts.create!(attributes_for(:contact))
      @location.services.create!(attributes_for(:service))
      @location.create_mail_address!(attributes_for(:mail_address))

      get api_org_locations_url(@org, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the location id attribute in the serialization' do
      expect(json.first['id']).to eq(@location.id)
    end

    it 'includes the location name attribute in the serialization' do
      expect(json.first['name']).to eq(@location.name)
    end

    it 'includes the location description attribute in the serialization' do
      expect(json.first['description']).to eq(@location.description)
    end

    it 'includes the location short_desc attribute in the serialization' do
      expect(json.first['short_desc']).to eq(@location.short_desc)
    end

    it 'includes the location latitude attribute in the serialization' do
      expect(json.first['latitude']).to eq(@location.latitude)
    end

    it 'includes the location longitude attribute in the serialization' do
      expect(json.first['longitude']).to eq(@location.longitude)
    end

    it 'includes the location slug attribute in the serialization' do
      expect(json.first['slug']).to eq(@location.slug)
    end

    it 'includes the location address attribute in the serialization' do
      expect(json.first['address']['street_1']).to eq(@location.address.street_1)
    end

    xit 'includes the location mail_address attribute in the serialization' do
      expect(json.first['mail_address']['city']).
        to eq(@location.mail_address.city)
    end

    it 'includes the location updated_at attribute in the serialization' do
      expect(json.first.keys).to include('updated_at')
    end

    it 'includes the location organization attribute in the serialization' do
      expect(json.first.keys).to include('organization')
    end

    it 'includes the location url attribute in the serialization' do
      expect(json.first['url']).
        to eq(api_location_url(@location, subdomain: ENV['API_SUBDOMAIN']))
    end

    it 'includes the contacts_url attribute in the serialization' do
      expect(json.first['contacts_url']).
        to eq(api_location_contacts_url(@location))
    end

    it 'includes the services_url attribute in the serialization' do
      expect(json.first['services_url']).
        to eq(api_location_services_url(@location))
    end

    it "doesn't include the location accessibility attribute" do
      expect(json.first.keys).to_not include('accessibility')
    end

    it 'includes the location admin_emails attribute' do
      expect(json.first.keys).to include('admin_emails')
    end

    it 'includes the location coordinates attribute' do
      expect(json.first.keys).to include('coordinates')
    end

    it "doesn't include the location emails attribute" do
      expect(json.first.keys).to_not include('emails')
    end

    it "doesn't include the location hours attribute" do
      expect(json.first.keys).to_not include('hours')
    end

    it "doesn't include the location languages attribute" do
      expect(json.first.keys).to_not include('languages')
    end

    it "doesn't include the location mail_address attribute" do
      expect(json.first.keys).to_not include('mail_address')
    end

    it "doesn't include the location transportation attribute" do
      expect(json.first.keys).to_not include('transportation')
    end

    it 'includes the location urls attribute' do
      expect(json.first.keys).to include('urls')
    end

    it "doesn't include the location contacts attribute" do
      expect(json.first.keys).to_not include('contacts')
    end

    it 'includes the location phones attribute' do
      expect(json.first.keys).to include('phones')
    end

    it "doesn't include the location services attribute" do
      expect(json.first.keys).to_not include('services')
    end
  end

  context "when organization doesn't have locations" do
    before :each do
      org = create(:organization)
      get api_org_locations_url(org, subdomain: ENV['API_SUBDOMAIN'])
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
