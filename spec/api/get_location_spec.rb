require 'rails_helper'

describe 'GET /locations/:id' do
  context 'with valid id' do
    before :each do
      create_service
      get api_endpoint(path: "/locations/#{@location.id}")
    end

    it 'includes the location id' do
      expect(json['id']).to eq(@location.id)
    end

    it 'includes the accessibility attribute with localized text' do
      expect(json['accessibility']).to eq(@location.accessibility.map(&:text))
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
      location_formatted_time = @location.updated_at.
        strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

      expect(json['updated_at']).to eq(location_formatted_time)
    end

    it 'includes the url attribute' do
      expect(json['url']).to eq("#{api_endpoint}/locations/#{@location.slug}")
    end

    it 'includes the serialized address association' do
      serialized_address =
        {
          'id'     => @location.address.id,
          'street' => @location.address.street,
          'city'   => @location.address.city,
          'state'  => @location.address.state,
          'zip'    => @location.address.zip
        }
      expect(json['address']).to eq(serialized_address)
    end

    it 'includes the serialized services association' do
      service_formatted_time = @location.services.first.updated_at.
        strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

      serialized_services =
        [{
          'id' => @location.services.reload.first.id,
          'description' => @location.services.first.description,
          'keywords' => @location.services.first.keywords,
          'name' => @location.services.first.name,
          'updated_at' => service_formatted_time
        }]

      expect(json['services']).to eq(serialized_services)
    end

    it 'includes the serialized organization association' do
      path = "#{api_endpoint}/organizations"
      locations_url = "#{path}/#{@location.organization.slug}/locations"

      serialized_organization =
        {
          'id' => @location.organization.id,
          'name' => 'Parent Agency',
          'slug' => 'parent-agency',
          'url' => "#{path}/#{@location.organization.slug}",
          'locations_url' => locations_url
        }

      expect(json['organization']).to eq(serialized_organization)
    end

    it 'includes the serialized mail_address association' do
      @location.create_mail_address!(attributes_for(:mail_address))
      get api_endpoint(path: "/locations/#{@location.id}")

      serialized_mail_address =
        {
          'id'        => @location.mail_address.id,
          'attention' => @location.mail_address.attention,
          'street'    => @location.mail_address.street,
          'city'      => @location.mail_address.city,
          'state'     => @location.mail_address.state,
          'zip'       => @location.mail_address.zip
        }
      expect(json['mail_address']).to eq(serialized_mail_address)
    end

    it 'displays contacts when present' do
      @location.contacts.create!(attributes_for(:contact))
      get api_endpoint(path: "/locations/#{@location.id}")
      expect(json['contacts']).
        to eq(
        [{
          'id'    => @location.contacts.first.id,
          'name'  => @location.contacts.first.name,
          'title' => @location.contacts.first.title
        }]
      )
    end

    it 'displays faxes when present' do
      @location.faxes.create!(attributes_for(:fax))
      get api_endpoint(path: "/locations/#{@location.id}")
      expect(json['faxes']).
        to eq(
        [{
          'id'    => @location.faxes.first.id,
          'number'  => @location.faxes.first.number,
          'department' => @location.faxes.first.department
        }]
      )
    end

    it 'displays phones when present' do
      @location.phones.create!(attributes_for(:phone))
      get api_endpoint(path: "/locations/#{@location.id}")
      expect(json['phones']).
        to eq(
        [{
          'id'    => @location.phones.first.id,
          'number'  => @location.phones.first.number,
          'department' => @location.phones.first.department,
          'extension' => @location.phones.first.extension,
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
      get api_endpoint(path: '/locations/1')
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

    it 'does not return nil fields when visiting one location' do
      get api_endpoint(path: "/locations/#{@loc.id}")
      keys = json.keys
      %w(faxes fees email).each do |key|
        expect(keys).not_to include(key)
      end
    end
  end
end
