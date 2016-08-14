require 'rails_helper'

describe 'GET /locations' do
  it 'returns an empty array when no locations exist' do
    get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(json).to eq([])
  end

  context 'when more than one location exists' do
    before(:all) do
      create(:location)
      create(:nearby_loc)
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns the correct number of existing locations' do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
    end

    it 'sorts results by creation date descending' do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      expect(json.first['name']).to eq('Library')
    end

    it 'responds to pagination parameters' do
      get api_locations_url(page: 2, per_page: 1, subdomain: ENV['API_SUBDOMAIN'])

      expect(json.length).to eq(1)
    end
  end

  describe 'serializations' do
    before(:all) do
      @location = create(:location)
    end

    before(:each) do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'includes the location id' do
      expect(json.first['id']).to eq(@location.id)
    end

    it 'does not include the accessibility attribute' do
      expect(json.first.keys).to_not include('accessibility')
    end

    it 'includes the alternate_name attribute' do
      expect(json.first.keys).to include('alternate_name')
    end

    it 'includes the coordinates attribute' do
      expect(json.first['coordinates']).to eq([@location.longitude, @location.latitude])
    end

    it 'includes the description attribute' do
      expect(json.first['description']).to eq(@location.description)
    end

    it 'includes the latitude attribute' do
      expect(json.first['latitude']).to eq(@location.latitude)
    end

    it 'includes the longitude attribute' do
      expect(json.first['longitude']).to eq(@location.longitude)
    end

    it 'includes the name attribute' do
      expect(json.first['name']).to eq(@location.name)
    end

    it 'includes the short_desc attribute' do
      expect(json.first['short_desc']).to eq(@location.short_desc)
    end

    it 'includes the slug attribute' do
      expect(json.first['slug']).to eq(@location.slug)
    end

    it 'includes the updated_at attribute' do
      expect(json.first.keys).to include('updated_at')
    end

    it 'includes the admin_emails attribute' do
      expect(json.first.keys).to include('admin_emails')
    end

    it 'does not include the email attribute' do
      expect(json.first.keys).to_not include('email')
    end

    it 'does not include the hours attribute' do
      expect(json.first.keys).to_not include('hours')
    end

    it 'does not include the languages attribute' do
      expect(json.first.keys).to_not include('languages')
    end

    it 'does not include the transportation attribute' do
      expect(json.first.keys).to_not include('transportation')
    end

    it 'includes the website attribute' do
      expect(json.first.keys).to include('website')
    end

    it 'includes the address association' do
      serialized_address =
        {
          'id' => @location.address.id,
          'address_1' => @location.address.address_1,
          'address_2' => nil,
          'city' => @location.address.city,
          'state_province' => @location.address.state_province,
          'postal_code' => @location.address.postal_code
        }
      expect(json.first['address']).to eq(serialized_address)
    end

    it 'does not include the mail_address association' do
      expect(json.first.keys).to_not include('mail_address')
    end

    it 'does not include the contacts association' do
      expect(json.first.keys).to_not include('contacts')
    end

    it 'does not include the services association' do
      expect(json.first.keys).to_not include('services')
    end

    it 'includes the phones association' do
      @location.phones.create!(attributes_for(:phone))
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])

      serialized_phones =
        [{
          'id'            => @location.phones.first.id,
          'number'        => @location.phones.first.number,
          'department'    => @location.phones.first.department,
          'extension'     => @location.phones.first.extension,
          'vanity_number' => @location.phones.first.vanity_number,
          'number_type'   => @location.phones.first.number_type
        }]

      expect(json.first['phones']).to eq(serialized_phones)
    end

    it 'includes a summarized organization association' do
      expect(json.first['organization'].keys).
        to eq(%w(id accreditations alternate_name date_incorporated
                 description email funding_sources licenses name
                 website slug url locations_url))
    end

    it 'does not include contacts within Organization' do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      org_keys = json.first['organization'].keys
      expect(org_keys).to_not include('contacts')
    end

    it 'includes the correct url attribute' do
      loc_url = json.first['url']

      get loc_url
      json = JSON.parse(response.body)
      expect(json['name']).to eq(@location.name)
    end
  end

  context 'with nil fields' do
    before(:all) do
      @loc = create(:loc_with_nil_fields)
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'returns nil fields within Location' do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      location_keys = json.first.keys
      nil_fields = %w(address coordinates phones)
      nil_fields.each do |key|
        expect(location_keys).to include(key)
      end
    end

    it 'returns nil fields within Phones' do
      @loc.phones.create!(attributes_for(:phone))
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      phone_keys = json.first['phones'].first.keys
      %w(extension vanity_number).each do |key|
        expect(phone_keys).to include(key)
      end
    end

    it 'returns nil fields within Organization' do
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      org_keys = json.first['organization'].keys
      expect(org_keys).to include('website')
    end
  end

  context 'when location has no physical address' do
    it 'exposes the coordinates field' do
      create(:no_address)
      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])
      location_keys = json.first.keys
      expect(location_keys).to include('coordinates')
    end
  end

  context 'when location has no active services' do
    it 'sets the active field to false' do
      location = create(:location)

      attrs =  attributes_for(:service)

      location.services.create!(attrs.merge(status: 'inactive'))
      location.services.create!(attrs.merge(status: 'inactive'))

      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])

      expect(json.first['active']).to eq false
    end
  end

  context 'when location has at least one active service' do
    it 'sets the active field to true' do
      location = create(:location)

      attrs =  attributes_for(:service)

      location.services.create!(attrs)
      location.services.create!(attrs.merge(status: 'inactive'))

      get api_locations_url(subdomain: ENV['API_SUBDOMAIN'])

      expect(json.first['active']).to eq true
    end
  end
end
