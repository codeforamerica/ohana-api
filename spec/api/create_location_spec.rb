require 'rails_helper'

describe 'Create a location (POST /organizations/:organization_id/locations/)' do
  before(:all) do
    @org = create(:organization)
  end

  before do
    @location_attributes = {
      name: 'new location',
      description: 'description',
      address_attributes: {
        address_1: 'main', city: 'utopia', state_province: 'CA', postal_code: '12345',
        country: 'US'
      }
    }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'creates a location with valid attributes' do
    post(
      api_organization_locations_url(@org, subdomain: ENV.fetch('API_SUBDOMAIN', nil)),
      @location_attributes
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@location_attributes[:name])
  end

  it 'returns a limited payload after creation' do
    post(
      api_organization_locations_url(@org, subdomain: ENV.fetch('API_SUBDOMAIN', nil)),
      @location_attributes
    )
    expect(json.keys).to eq(%w[id name slug])
  end

  it 'returns a Location header with the URL to the new location' do
    post(
      api_organization_locations_url(@org, subdomain: ENV.fetch('API_SUBDOMAIN', nil)),
      @location_attributes
    )
    expect(headers['Location']).
      to eq(api_location_url('new-location', subdomain: ENV.fetch('API_SUBDOMAIN', nil)))
  end

  it "doesn't create a location with invalid attributes" do
    post(
      api_organization_locations_url(@org, subdomain: ENV.fetch('API_SUBDOMAIN', nil)),
      name: nil
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Location"])
  end

  it "doesn't allow creating a location without a valid token" do
    post(
      api_organization_locations_url(@org, subdomain: ENV.fetch('API_SUBDOMAIN', nil)),
      @location_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
