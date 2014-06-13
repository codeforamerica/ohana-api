require 'spec_helper'

describe Ohana::API do

  describe 'Location Requests' do
    include DefaultUserAgent
    include Features::SessionHelpers

    describe 'GET /api/locations' do
      it 'returns an empty array when no locations exist' do
        get '/api/locations'
        expect(response).to be_success
        expect(json).to eq([])
      end

      it 'returns the correct number of existing locations' do
        create_list(:location, 2)
        get '/api/locations'
        expect(response).to be_success
        expect(json.length).to eq(2)
      end

      it 'sorts results by creation date descending' do
        loc1 = create(:location)
        create(:nearby_loc)
        get '/api/locations?page=2&per_page=1'
        expect(response).to be_success
        expect(json.length).to eq(1)
        expect(json.first['accessibility']).
          to eq(['Information on tape or in Braille', 'Disabled Parking'])
        expect(json.first['organization'].keys).to include('locations_url')
        expect(json.first['url']).
          to eq("#{ENV['API_BASE_URL']}locations/#{loc1.id}")
        expect(json.first['organization']['url']).
          to eq("#{ENV['API_BASE_URL']}organizations/#{loc1.organization.id}")
      end

      it 'displays address when present' do
        create(:location)
        get '/api/locations'
        expect(json.first['address']['street']).to eq('1800 Easton Drive')
      end

      it 'displays mail_address when present' do
        loc = create(:location)
        loc.create_mail_address!(attributes_for(:mail_address))
        get '/api/locations'
        expect(json.first['mail_address']['street']).to eq('1 davis dr')
      end

      it 'displays contacts when present' do
        loc = create(:location)
        loc.contacts.create!(attributes_for(:contact))
        get '/api/locations'
        expect(json.first['contacts'].first['title']).to eq('CTO')
      end

      it 'displays faxes when present' do
        loc = create(:location)
        loc.faxes.create!(attributes_for(:fax))
        get '/api/locations'
        expect(json.first['faxes'].first['number']).to eq('703-555-1212')
      end

      it 'displays phones when present' do
        loc = create(:location)
        loc.phones.create!(attributes_for(:phone))
        get '/api/locations'
        expect(json.first['phones'].first['extension']).to eq('x2000')
      end

      context 'with nil fields' do

        before(:each) do
          @loc = create(:loc_with_nil_fields)
        end

        it 'does not return nil fields within Location' do
          get 'api/locations'
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
          get 'api/locations'
          contact_keys = json.first['contacts'].first.keys
          %w(phone fax email).each do |key|
            expect(contact_keys).not_to include(key)
          end
        end

        it 'does not return nil fields within Faxes' do
          @loc.faxes.create!(attributes_for(:fax_with_no_dept))
          get 'api/locations'
          fax_keys = json.first['faxes'].first.keys
          expect(fax_keys).not_to include('department')
        end

        it 'does not return nil fields within Phones' do
          @loc.phones.create!(attributes_for(:phone_with_missing_fields))
          get 'api/locations'
          phone_keys = json.first['phones'].first.keys
          %w(extension vanity_number).each do |key|
            expect(phone_keys).not_to include(key)
          end
        end

        it 'does not return nil fields within Organization' do
          get 'api/locations'
          org_keys = json.first['organization'].keys
          expect(org_keys).not_to include('urls')
        end

        it 'does not return nil fields within Services' do
          attrs = attributes_for(:service)
          @loc.services.create!(attrs)
          get 'api/locations'
          service_keys = json.first['services'].first.keys
          %w(audience eligibility fees).each do |key|
            expect(service_keys).not_to include(key)
          end
        end
      end

      context 'when location has no physical address' do
        it 'does not return nil coordinates' do
          create(:no_address)
          get 'api/locations'
          location_keys = json.first.keys
          expect(location_keys).not_to include('coordinates')
        end
      end
    end

    describe 'GET /api/locations/:id' do
      context 'with valid data' do
        before :each do
          create_service
          get "/api/locations/#{@location.id}"
        end

        it 'returns a status by id' do
          path = "#{ENV['API_BASE_URL']}organizations"

          service_formatted_time = @location.services.first.updated_at.
            strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

          location_formatted_time = @location.updated_at.
            strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

          locations_url = "#{path}/#{@location.organization.id}/locations"

          represented = {
            'id' => @location.id,
            'accessibility' => @location.accessibility.map(&:text),
            'address' => {
              'id'     => @location.address.id,
              'street' => @location.address.street,
              'city'   => @location.address.city,
              'state'  => @location.address.state,
              'zip'    => @location.address.zip
            },
            'coordinates' => @location.coordinates,
            'description' => @location.description,
            'latitude' => @location.latitude,
            'longitude' => @location.longitude,
            'name' => @location.name,
            'short_desc' => 'short description',
            'slug' => 'vrs-services',
            'updated_at' => location_formatted_time,
            'url' => "#{ENV['API_BASE_URL']}locations/#{@location.id}",
            'services' => [{
              'id' => @location.services.reload.first.id,
              'description' => @location.services.first.description,
              'keywords' => @location.services.first.keywords,
              'name' => @location.services.first.name,
              'updated_at' => service_formatted_time
            }],
            'organization' => {
              'id' => @location.organization.id,
              'name' => 'Parent Agency',
              'slug' => 'parent-agency',
              'url' => "#{path}/#{@location.organization.id}",
              'locations_url' => locations_url
            }
          }
          expect(json).to eq(represented)
        end

        it 'is json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'returns a successful status code' do
          expect(response).to be_success
        end

        it "returns the location's street" do
          expect(json['address']['street']).to eq('1800 Easton Drive')
        end
      end

      context 'with invalid data' do

        before :each do
          get '/api/locations/1'
        end

        it 'returns a not found error' do
          expect(json['error']).to eq('Not Found')
        end

        it 'returns a 404 status code' do
          expect(response.status).to eq(404)
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
          get "api/locations/#{@loc.id}"
          keys = json.keys
          %w(faxes fees email).each do |key|
            expect(keys).not_to include(key)
          end
        end

        it 'does not return nil fields when searching for location' do
          get 'api/search?keyword=belmont'
          keys = json.first.keys
          %w(faxes fees email).each do |key|
            expect(keys).not_to include(key)
          end
        end
      end
    end

    describe 'Update a location (PUT /api/locations/:id)' do
      before(:each) do
        @loc = create(:location)
        @token = ENV['ADMIN_APP_TOKEN']
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put(
          "api/locations/#{@loc.id}",
          { foo: 'bar' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response).to be_success
        expect(json).not_to include 'foo'
      end

      it 'allows setting whitelisted attributes' do
        put(
          "api/locations/#{@loc.id}",
          { name: 'New Name' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response).to be_success
        expect(json['name']).to eq('New Name')
      end

      it 'validates the accessibility attribute' do
        put(
          "api/locations/#{@loc.id}",
          { accessibility: 'Human Services' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Please enter a valid value for Accessibility'
      end

      it 'validates phone number' do
        put(
          "api/locations/#{@loc.id}",
          { phones_attributes: [{ number: '703' }] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include '703 is not a valid US phone number'
      end

      it 'validates fax number' do
        put(
          "api/locations/#{@loc.id}",
          { faxes_attributes: [{ number: '703' }] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include '703 is not a valid US fax number'
      end

      it 'allows empty array for faxes_attributes' do
        put(
          "api/locations/#{@loc.id}",
          { faxes_attributes: [] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(200)
      end

      it 'validates admin email' do
        put(
          "api/locations/#{@loc.id}",
          { admin_emails: ['moncef-at-ohanapi.org'] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'moncef-at-ohanapi.org is not a valid email'
      end

      it 'validates admin_emails is an array' do
        put(
          "api/locations/#{@loc.id}",
          { admin_emails: 'moncef@ohanapi.org' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Attribute was supposed to be a Array, but was a String.'
      end

      it 'allows empty admin_emails array' do
        put(
          "api/locations/#{@loc.id}",
          { admin_emails: [] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(200)
      end

      it 'allows valid admin_emails array' do
        put(
          "api/locations/#{@loc.id}",
          { admin_emails: ['moncef@ohanapi.org'] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(200)
      end

      it 'requires description' do
        put(
          "api/locations/#{@loc.id}",
          { description: '' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "Description can't be blank"
      end

      # Enable this test if you would like to require a short description
      # Remove the "x" before "it" to enable the test.
      xit 'requires short description' do
        put(
          "api/locations/#{@loc.id}",
          { short_desc: '' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "Short desc can't be blank"
      end

      # Enable this test if you want to limit the short description's length
      # Remove the 'x' before 'it' to enable the test.
      xit 'limits short description to 200 characters' do
        put(
          "api/locations/#{@loc.id}",
          { short_desc: 'A 6 month residential co-ed treatment program
            designed to provide homeless veterans with the skills necessary
            to function self-sufficiently in society. Residents attend schools
            all day' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include 'too long (maximum is 200 characters)'
      end

      it 'requires location name' do
        put(
          "api/locations/#{@loc.id}",
          { name: '' },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "Name can't be blank"
      end

      it 'validates location email' do
        put(
          "api/locations/#{@loc.id}",
          { emails: ['703', 'mo@cfa.org'] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include '703 is not a valid email'
      end

      it 'validates location URLs' do
        put(
          "api/locations/#{@loc.id}",
          { urls: ['badurl'] },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include 'badurl is not a valid URL'
      end

      it 'validates location address state' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: '123', city: 'utopia', state: 'C', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Please enter a valid 2-letter state abbreviation'
      end

      it 'validates location address zip' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: '123', city: 'utopia', state: 'CA', zip: '1234' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include '1234 is not a valid ZIP code'
      end

      it 'requires location address street' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: '', city: 'utopia', state: 'CA', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "street can't be blank"
      end

      it 'requires location address state' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: 'boo', city: 'utopia', state: '', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "state can't be blank"
      end

      it 'requires location address city' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: 'funu', city: '', state: 'CA', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "city can't be blank"
      end

      it 'requires location address zip' do
        put(
          "api/locations/#{@loc.id}",
          { address_attributes: {
            street: 'jam', city: 'utopia', state: 'CA', zip: '' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "zip can't be blank"
      end

      it 'validates location mail address state' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: '123', city: 'utopia', state: 'C', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Please enter a valid 2-letter state abbreviation'
      end

      it 'validates location mail address zip' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: '123', city: 'belmont', state: 'CA', zip: '1234' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include '1234 is not a valid ZIP code'
      end

      it 'requires location mail_address street' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: '', city: 'utopia', state: 'CA', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "street can't be blank"
      end

      it 'requires location mail_address state' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: 'boo', city: 'utopia', state: '', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "state can't be blank"
      end

      it 'requires location mail_address city' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: 'funu', city: '', state: 'CA', zip: '12345' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "city can't be blank"
      end

      it 'requires location mail_address zip' do
        put(
          "api/locations/#{@loc.id}",
          { mail_address_attributes: {
            street: 'jam', city: 'utopia', state: 'CA', zip: '' }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).to include "zip can't be blank"
      end

      it 'rejects location with neither address nor mail address' do
        put(
          "api/locations/#{@loc.id}",
          { address: nil },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'A location must have at least one address type.'
      end

      it "doesn't geocode when address hasn't changed" do
        @loc.update(name: 'new name')
        expect(@loc).not_to receive(:geocode)
        @loc.save!
      end

      it 'geocodes when address has changed' do
        address = {
          street: '1 davis drive', city: 'belmont', state: 'CA', zip: '94002'
        }
        coords = @loc.coordinates

        put(
          "api/locations/#{@loc.id}",
          { address_attributes: address },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(@loc.coordinates).to_not eq(coords)
      end

      it 'resets coordinates when address is removed' do
        put(
          "api/locations/#{@loc.id}",
          {
            address: nil,
            mail_address_attributes: {
              street: '1 davis drive', city: 'belmont',
              state: 'CA', zip: '94002'
            }
          },
          'HTTP_X_API_TOKEN' => @token
        )
        @loc.reload
        expect(@loc.coordinates).to be_nil
      end

      it 'updates the search index when location changes' do
        put(
          "api/locations/#{@loc.id}",
          { name: 'changeme' },
          'HTTP_X_API_TOKEN' => @token
        )
        get '/api/search?keyword=changeme'
        expect(json.first['name']).to eq('changeme')
      end
    end

    describe 'Update a location without a valid token' do
      it "doesn't allow updating a location witout a valid token" do
        @loc = create(:location)
        put(
          "api/locations/#{@loc.id}",
          { name: 'new name' },
          'HTTP_X_API_TOKEN' => 'invalid_token'
        )
        @loc.reload
        expect(response.status).to eq(401)
      end
    end

    describe "Update a location's slug" do
      before(:each) do
        @loc = create(:location)
        @token = ENV['ADMIN_APP_TOKEN']
      end

      it 'is accessible by its old slug' do
        put(
          "api/locations/#{@loc.id}",
          { name: 'new name' },
          'HTTP_X_API_TOKEN' => @token
        )
        get 'api/locations/vrs-services'
        expect(json['name']).to eq('new name')
      end
    end

    describe 'Create a location (POST /api/locations/)' do
      before(:each) do
        org = create(:organization)
        @required_attributes = {
          name: 'new location',
          description: 'description',
          short_desc: 'short_desc',
          address_attributes: {
            street: 'main', city: 'utopia', state: 'CA', zip: '12345' },
          organization_id: org.id
        }
      end
      it "doesn't allow setting non-whitelisted attributes" do
        post(
          'api/locations/',
          @required_attributes.merge(foo: 'bar'),
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
        expect(response.status).to eq(201)
        expect(json).not_to include 'foo'
      end
    end

    describe 'POST /api/locations/:id/services' do
      before(:each) do
        @loc = create(:location)
        @service_attributes = {
          fees: 'new fees',
          audience: 'new audience',
          keywords: %w(food youth)
        }
      end

      it "doesn't allow setting non-whitelisted attributes" do
        post(
          "api/locations/#{@loc.id}/services",
          @service_attributes.merge(foo: 'bar'),
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
        expect(response.status).to eq(201)
        expect(json).not_to include 'foo'
      end

      it 'allows setting whitelisted attributes' do
        post(
          "api/locations/#{@loc.id}/services",
          @service_attributes,
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
        expect(json['audience']).to eq 'new audience'
        expect(json['fees']).to eq 'new fees'
        expect(json['keywords']).to eq %w(food youth)
      end

      it 'sets service_areas to empty array if empty string' do
        post(
          "api/locations/#{@loc.id}/services",
          @service_attributes.merge(services_areas: ''),
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
        expect(json['service_areas']).to eq([])
      end

      it 'sets service_areas to empty array if nil' do
        post(
          "api/locations/#{@loc.id}/services",
          @service_attributes.merge(services_areas: nil),
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
        expect(json['service_areas']).to eq([])
      end
    end

    describe 'DELETE api/locations/:id' do
      before :each do
        create_service
        @service_id = @service.id
        @id = @location.id
        delete(
          "api/locations/#{@id}",
          {},
          'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
        )
      end

      it 'deletes the location' do
        get "api/locations/#{@id}"
        expect(response.status).to eq(404)
      end

      it 'deletes the service too' do
        expect { Service.find(@service_id) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'updates the search index' do
        get 'api/search?keyword=vrs'
        expect(json.length).to eq(0)
      end
    end
  end
end
