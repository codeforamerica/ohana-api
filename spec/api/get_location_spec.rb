require 'rails_helper'

describe 'GET /locations/:id' do
  context 'with valid id' do
    before :all do
      create_service
    end

    before(:each) do
      @location.reload
      get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'includes the location id' do
      expect(json['id']).to eq(@location.id)
    end

    it 'includes the accessibility attribute with localized text' do
      expect(json['accessibility']).to eq(@location.accessibility.map(&:text))
    end

    it 'includes the alternate_name attribute' do
      expect(json['alternate_name']).to eq(@location.alternate_name)
    end

    it 'includes the coordinates attribute' do
      expect(json['coordinates']).to eq(@location.coordinates)
    end

    it 'includes the description attribute' do
      expect(json['description']).to eq(@location.description)
    end

    it 'includes the latitude attribute' do
      expect(json['latitude']).to eq(@location.latitude)
    end

    it 'includes the longitude attribute' do
      expect(json['longitude']).to eq(@location.longitude)
    end

    it 'includes the name attribute' do
      expect(json['name']).to eq(@location.name)
    end

    it 'includes the short_desc attribute' do
      expect(json['short_desc']).to eq(@location.short_desc)
    end

    it 'includes the slug attribute' do
      expect(json['slug']).to eq(@location.slug)
    end

    it 'includes the updated_at attribute' do
      expect(json.keys).to include('updated_at')
    end

    it 'includes the url attribute' do
      expect(json['url']).to eq(api_location_url(@location))
    end

    it 'includes the serialized address association' do
      serialized_address =
        {
          'id'     => @location.address.id,
          'street_1' => @location.address.street_1,
          'street_2' => nil,
          'city'   => @location.address.city,
          'state'  => @location.address.state,
          'postal_code'    => @location.address.postal_code
        }
      expect(json['address']).to eq(serialized_address)
    end

    it 'includes the serialized services association' do
      service_formatted_time = @location.services.first.updated_at.
        strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

      serialized_services =
        [{
          'id'              => @location.services.reload.first.id,
          'audience'        => nil,
          'description'     => @location.services.first.description,
          'eligibility'     => nil,
          'fees'            => nil,
          'funding_sources' => [],
          'how_to_apply'    => nil,
          'keywords'        => @location.services.first.keywords,
          'name'            => @location.services.first.name,
          'service_areas'   => [],
          'short_desc'      => nil,
          'urls'            => [],
          'wait'            => nil,
          'updated_at'      => service_formatted_time,
          'categories'      => []
        }]

      expect(json['services']).to eq(serialized_services)
    end

    it 'includes the serialized organization association' do
      org = @location.organization
      locations_url = api_org_locations_url(org)

      serialized_organization =
        {
          'id'                => @location.organization.id,
          'alternate_name'    => nil,
          'date_incorporated' => nil,
          'description'       => 'Organization created for testing purposes',
          'email'             => nil,
          'locations_url'     => locations_url,
          'name'              => 'Parent Agency',
          'slug'              => 'parent-agency',
          'url'               => api_organization_url(org),
          'website'           => nil
        }

      expect(json['organization']).to eq(serialized_organization)
    end

    it 'includes the serialized mail_address association' do
      @location.create_mail_address!(attributes_for(:mail_address))
      get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])

      serialized_mail_address =
        {
          'id'        => @location.mail_address.id,
          'attention' => @location.mail_address.attention,
          'street_1'    => @location.mail_address.street_1,
          'street_2' => nil,
          'city'      => @location.mail_address.city,
          'state'     => @location.mail_address.state,
          'postal_code'       => @location.mail_address.postal_code
        }
      expect(json['mail_address']).to eq(serialized_mail_address)
    end

    it 'displays contacts when present' do
      @location.contacts.create!(attributes_for(:contact))
      get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['contacts']).
        to eq(
        [{
          'id'        => @location.contacts.first.id,
          'email'     => nil,
          'name'      => @location.contacts.first.name,
          'department'     => nil,
          'title'     => @location.contacts.first.title,
          'phones'    => @location.contacts.first.phones
        }]
      )
    end

    it 'displays phones when present' do
      @location.phones.create!(attributes_for(:phone))
      get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['phones']).
        to eq(
        [{
          'id'            => @location.phones.first.id,
          'department'    => @location.phones.first.department,
          'extension'     => @location.phones.first.extension,
          'number'        => @location.phones.first.number,
          'number_type'   => @location.phones.first.number_type,
          'vanity_number' => @location.phones.first.vanity_number
        }]
      )
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(200)
    end
  end

  context 'with invalid id' do

    before :each do
      get api_location_url(1, subdomain: ENV['API_SUBDOMAIN'])
    end

    it 'returns a status key equal to 404' do
      expect(json['status']).to eq(404)
    end

    it 'returns a helpful message' do
      expect(json['message']).
        to eq('The requested resource could not be found.')
    end

    it 'returns a 404 status code' do
      expect(response).to have_http_status(404)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end
  end

  context 'with nil fields' do

    before(:each) do
      @loc = create(:loc_with_nil_fields)
    end

    it 'returns nil fields when visiting one location' do
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      keys = json.keys
      %w(admin_emails emails accessibility hours).each do |key|
        expect(keys).to include(key)
      end
    end
  end
end
