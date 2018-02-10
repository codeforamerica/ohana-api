require 'rails_helper'

describe 'PATCH /locations/:id)' do
  let(:attributes) do
    {
      accessibility: %w[disabled_parking ramp],
      active: true,
      admin_emails: ['foo@test.com', 'bar@test.com'],
      alternate_name: 'Different Name',
      description: 'test location',
      email: 'test@test.com',
      hours: 'M-F 9am-5pm',
      importance: 3,
      kind: 'farmers_markets',
      languages: %w[French Tagalog],
      latitude: 37.3180168,
      longitude: -122.2743951,
      market_match: true,
      name: 'Test Location',
      payments: ['Credit Card', 'CalFresh'],
      products: %w[Cheese Flowers],
      short_desc: 'short description',
      transportation: 'BART stop 1 block away.',
      website: 'https://www.example.com',
      virtual: true,
      address_attributes: {
        address_1: 'main', city: 'utopia', state_province: 'CA', postal_code: '12345',
        country: 'US'
      }
    }
  end

  before(:each) do
    @loc = create(:location)
  end

  it 'returns the updated location when validations pass' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), attributes

    expect(response).to have_http_status(200)
    expect(json['accessibility']).to eq ['Disabled Parking', 'Ramp']
    expect(json['kind']).to eq "Farmers' Markets"
    expect(json['address']['address_1']).to eq attributes[:address_attributes][:address_1]
    attributes.each do |key, value|
      next if %i[accessibility address_attributes importance kind virtual].include?(key)
      expect(json[key.to_s]).to eq value
    end
    expect(@loc.reload.importance).to eq 1
    expect(@loc.reload.virtual).to eq true
  end

  it 'does not modify admin_emails if set to empty string' do
    @loc.update!(admin_emails: %w[test@test.com foo@test.com])
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), admin_emails: ''
    expect(@loc.reload.admin_emails).to eq %w[test@test.com foo@test.com]
    expect(response.status).to eq(200)
    expect(json['admin_emails']).to eq %w[test@test.com foo@test.com]
  end

  it 'does not modify admin_emails if set to a String' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          admin_emails: 'moncef@cfa.com'

    expect(@loc.reload.admin_emails).to eq []
    expect(response.status).to eq(200)
    expect(json['admin_emails']).to eq []
  end

  it 'does not modify languages if set to empty string' do
    @loc.update!(languages: ['English'])
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), languages: ''
    expect(@loc.reload.languages).to eq ['English']
    expect(response.status).to eq(200)
    expect(json['languages']).to eq ['English']
  end

  it 'sets languages to empty array if value is empty array' do
    @loc.update!(languages: %w[French Arabic])
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), languages: []
    expect(json['languages']).to eq([])
  end

  it 'returns 422 when attribute is invalid' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          admin_emails: ['moncef-at-ohanapi.org']

    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first).
      to eq('admin_emails' => ['moncef-at-ohanapi.org is not a valid email'])
  end

  it 'returns 422 when required attribute is missing' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          description: ''

    expect(response.status).to eq(422)
    expect(json['errors'].first).
      to eq('description' => ["can't be blank for Location"])
  end

  it 'returns 404 when id is missing' do
    patch api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
          description: ''

    expect(response.status).to eq(404)
    expect(json['message']).to eq('The requested resource could not be found.')
  end

  it 'updates the search index when location changes' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          name: 'changeme'

    get api_search_index_url(keyword: 'changeme', subdomain: ENV['API_SUBDOMAIN'])
    expect(json.first['name']).to eq('changeme')
  end

  it 'is accessible by its old slug' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          name: 'new name'

    get api_location_url('vrs-services', subdomain: ENV['API_SUBDOMAIN'])
    expect(json['name']).to eq('new name')
  end

  it "doesn't allow updating a location without a valid token" do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          { name: 'new name' },
          'HTTP_X_API_TOKEN' => 'invalid_token'

    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
