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
      api_endpoint(path: '/locations/'),
      @required_attributes,
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@required_attributes[:name])
  end

  it 'returns a Location header with the URL to the new location' do
    post(
      api_endpoint(path: '/locations/'),
      @required_attributes,
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(headers['Location']).to eq("#{api_endpoint}/locations/new-location")
  end

  it "doesn't create a location with invalid attributes" do
    post(
      api_endpoint(path: '/locations/'),
      { name: nil },
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Location"])
  end

  it "doesn't allow creating a location without a valid token" do
    post(
      api_endpoint(path: '/locations/'),
      @required_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
