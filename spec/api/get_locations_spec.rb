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
    end

    it 'displays address when present' do
      get api_endpoint(path: '/locations')
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

    it 'displays mail_address when present' do
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

    it 'displays contacts when present' do
      @location.contacts.create!(attributes_for(:contact))
      get api_endpoint(path: '/locations')

      serialized_contacts =
        [{
          'id'    => @location.contacts.first.id,
          'name'  => @location.contacts.first.name,
          'title' => @location.contacts.first.title
        }]
      expect(json.first['contacts']).to eq(serialized_contacts)
    end

    it 'displays faxes when present' do
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

    it 'displays phones when present' do
      @location.phones.create!(attributes_for(:phone))
      get api_endpoint(path: '/locations')

      serialized_phones =
        [{
          'id'            => @location.phones.first.id,
          'number'        => @location.phones.first.number,
          'department'    => @location.phones.first.department,
          'extension'     => @location.phones.first.extension,
          'vanity_number' => @location.phones.first.vanity_number
        }]

      expect(json.first['phones']).to eq(serialized_phones)
    end

    it 'includes the organization association' do
      get api_endpoint(path: '/locations')
      expect(json.first.keys).to include('organization')
    end

    it 'includes the correct url attribute' do
      get api_endpoint(path: '/locations')
      loc_url = json.first['url']

      get loc_url
      json = JSON.parse(response.body)
      expect(json['name']).to eq(@location.name)
    end
  end

  context 'with nil fields' do

    before(:each) do
      @loc = create(:loc_with_nil_fields)
    end

    it 'does not return nil fields within Location' do
      get api_endpoint(path: '/locations')
      location_keys = json.first.keys
      missing_keys = %w(
        accessibility admin_emails contacts emails faxes
        hours languages mail_address phones transportation urls services
      )
      missing_keys.each do |key|
        expect(location_keys).not_to include(key)
      end
    end

    it 'does not return nil fields within Contacts' do
      attrs = attributes_for(:contact)
      @loc.contacts.create!(attrs)
      get api_endpoint(path: '/locations')
      contact_keys = json.first['contacts'].first.keys
      %w(phone fax email).each do |key|
        expect(contact_keys).not_to include(key)
      end
    end

    it 'does not return nil fields within Faxes' do
      @loc.faxes.create!(attributes_for(:fax_with_no_dept))
      get api_endpoint(path: '/locations')
      fax_keys = json.first['faxes'].first.keys
      expect(fax_keys).not_to include('department')
    end

    it 'does not return nil fields within Phones' do
      @loc.phones.create!(attributes_for(:phone_with_missing_fields))
      get api_endpoint(path: '/locations')
      phone_keys = json.first['phones'].first.keys
      %w(extension vanity_number).each do |key|
        expect(phone_keys).not_to include(key)
      end
    end

    it 'does not return nil fields within Organization' do
      get api_endpoint(path: '/locations')
      org_keys = json.first['organization'].keys
      expect(org_keys).not_to include('urls')
    end

    it 'does not return nil fields within Services' do
      attrs = attributes_for(:service)
      @loc.services.create!(attrs)
      get api_endpoint(path: '/locations')
      service_keys = json.first['services'].first.keys
      %w(audience eligibility fees).each do |key|
        expect(service_keys).not_to include(key)
      end
    end
  end

  context 'when location has no physical address' do
    it 'does not return nil coordinates' do
      create(:no_address)
      get api_endpoint(path: '/locations')
      location_keys = json.first.keys
      expect(location_keys).not_to include('coordinates')
    end
  end
end
