require 'rails_helper'

describe 'GET /locations' do
  it 'returns an empty array when no locations exist' do
    get api_endpoint(path: '/locations')
    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(json).to eq([])
  end

  context 'when more than one location exists' do
    before(:each) do
      create(:location)
      create(:nearby_loc)
    end

    it 'returns the correct number of existing locations' do
      get api_endpoint(path: '/locations')
      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
    end

    it 'sorts results by creation date descending' do
      get api_endpoint(path: '/locations')
      expect(json.first['name']).to eq('Library')
    end

    it 'responds to pagination parameters' do
      get api_endpoint(path: '/locations?page=2&per_page=1')

      expect(json.length).to eq(1)
    end
  end

  describe 'serializations' do
    before(:each) do
      @location = create(:location)
      get api_endpoint(path: '/locations')
    end

    it 'includes the location id' do
      expect(json.first['id']).to eq(@location.id)
    end

    it 'does not include the accessibility attribute' do
      expect(json.first.keys).to_not include('accessibility')
    end

    it 'includes the coordinates attribute' do
      expect(json.first['coordinates']).to eq(@location.coordinates)
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

    it 'does not include the emails attribute' do
      expect(json.first.keys).to_not include('emails')
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

    it 'includes the urls attribute' do
      expect(json.first.keys).to include('urls')
    end

    it 'includes the address association' do
      serialized_address =
        {
          'id'     => @location.address.id,
          'street' => @location.address.street,
          'city'   => @location.address.city,
          'state'  => @location.address.state,
          'zip'    => @location.address.zip
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
      get api_endpoint(path: '/locations')

      serialized_phones =
        [{
          'id'            => @location.phones.first.id,
          'number'        => @location.phones.first.number,
          'department'    => @location.phones.first.department,
          'extension'     => @location.phones.first.extension,
          'vanity_number' => @location.phones.first.vanity_number,
          'number_type'   => nil
        }]

      expect(json.first['phones']).to eq(serialized_phones)
    end

    it 'includes the organization association' do
      expect(json.first.keys).to include('organization')
    end

    it 'includes the correct url attribute' do
      loc_url = json.first['url']

      get loc_url
      json = JSON.parse(response.body)
      expect(json['name']).to eq(@location.name)
    end

    it 'includes the contacts_url attribute' do
      expect(json.first['contacts_url']).
        to eq("#{api_endpoint}/locations/#{@location.slug}/contacts")
    end

    it 'includes the faxes_url attribute' do
      expect(json.first['faxes_url']).
        to eq("#{api_endpoint}/locations/#{@location.slug}/faxes")
    end

    it 'includes the services_url attribute' do
      expect(json.first['services_url']).
        to eq("#{api_endpoint}/locations/#{@location.slug}/services")
    end

    xit 'displays mail_address when present' do
      @location.create_mail_address!(attributes_for(:mail_address))
      get api_endpoint(path: '/locations')

      serialized_mail_address =
        {
          'id'        => @location.mail_address.id,
          'attention' => @location.mail_address.attention,
          'street'    => @location.mail_address.street,
          'city'      => @location.mail_address.city,
          'state'     => @location.mail_address.state,
          'zip'       => @location.mail_address.zip
        }
      expect(json.first['mail_address']).to eq(serialized_mail_address)
    end

    xit 'displays contacts when present' do
      @location.contacts.create!(attributes_for(:contact))
      get api_endpoint(path: '/locations')

      serialized_contacts =
        [{
          'id'    => @location.contacts.first.id,
          'name'  => @location.contacts.first.name,
          'title' => @location.contacts.first.title,
          'phone' => nil,
          'email' => nil,
          'extension' => nil,
          'fax'   => nil
        }]
      expect(json.first['contacts']).to eq(serialized_contacts)
    end

    xit 'displays faxes when present' do
      @location.faxes.create!(attributes_for(:fax))
      get api_endpoint(path: '/locations')

      serialized_faxes =
        [{
          'id'         => @location.faxes.first.id,
          'number'     => @location.faxes.first.number,
          'department' => @location.faxes.first.department
        }]

      expect(json.first['faxes']).to eq(serialized_faxes)
    end
  end

  context 'with nil fields' do

    before(:each) do
      @loc = create(:loc_with_nil_fields)
    end

    it 'returns nil fields within Location' do
      get api_endpoint(path: '/locations')
      location_keys = json.first.keys
      nil_fields = %w(address coordinates phones)
      nil_fields.each do |key|
        expect(location_keys).to include(key)
      end
    end

    xit 'returns nil fields within Contacts' do
      attrs = attributes_for(:contact)
      @loc.contacts.create!(attrs)
      get api_endpoint(path: '/locations')
      contact_keys = json.first['contacts'].first.keys
      %w(phone fax email).each do |key|
        expect(contact_keys).to include(key)
      end
    end

    xit 'returns nil fields within Faxes' do
      @loc.faxes.create!(attributes_for(:fax_with_no_dept))
      get api_endpoint(path: '/locations')
      fax_keys = json.first['faxes'].first.keys
      expect(fax_keys).to include('department')
    end

    it 'returns nil fields within Phones' do
      @loc.phones.create!(attributes_for(:phone_with_missing_fields))
      get api_endpoint(path: '/locations')
      phone_keys = json.first['phones'].first.keys
      %w(extension vanity_number).each do |key|
        expect(phone_keys).to include(key)
      end
    end

    it 'returns nil fields within Organization' do
      get api_endpoint(path: '/locations')
      org_keys = json.first['organization'].keys
      expect(org_keys).to include('urls')
    end

    xit 'returns nil fields within Services' do
      attrs = attributes_for(:service)
      @loc.services.create!(attrs)
      get api_endpoint(path: '/locations')
      service_keys = json.first['services'].first.keys
      %w(audience eligibility fees).each do |key|
        expect(service_keys).to include(key)
      end
    end
  end

  context 'when location has no physical address' do
    it 'returns nil coordinates' do
      create(:no_address)
      get api_endpoint(path: '/locations')
      location_keys = json.first.keys
      expect(location_keys).to include('coordinates')
    end
  end
end
