require 'rails_helper'

describe 'Create a location (POST /locations/)' do
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

  it 'creates a location with valid attributes' do
    post(
      api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
      @required_attributes
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@required_attributes[:name])
  end

  it 'returns a limited payload after creation' do
    post(
      api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
      @required_attributes
    )
    expect(json.keys).to eq(%w(id name slug))
  end

  it 'returns a Location header with the URL to the new location' do
    post(
      api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
      @required_attributes
    )
    expect(headers['Location']).
      to eq(api_location_url('new-location', subdomain: ENV['API_SUBDOMAIN']))
  end

  it "doesn't create a location with invalid attributes" do
    post(
      api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
      name: nil
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Location"])
  end

  it "doesn't allow creating a location without a valid token" do
    post(
      api_locations_url(subdomain: ENV['API_SUBDOMAIN']),
      @required_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
