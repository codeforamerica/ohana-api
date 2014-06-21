require 'rails_helper'

describe 'Create an organization (POST /organizations/)' do
  before(:each) do
    create(:organization)
    @org_attributes = { name: 'new org', urls: %w(http://monfresh.com) }
  end

  it 'creates an organization with valid attributes' do
    post(
      api_endpoint(path: '/organizations/'),
      @org_attributes,
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@org_attributes[:name])
  end

  it 'returns a Location header with the URL to the new organization' do
    post(
      api_endpoint(path: '/organizations/'),
      @org_attributes,
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(headers['Location']).to eq("#{api_endpoint}/organizations/new-org")
  end

  it "doesn't create an organization with invalid attributes" do
    post(
      api_endpoint(path: '/organizations/'),
      { name: nil },
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Organization"])
  end

  it "doesn't allow creating an organization without a valid token" do
    post(
      api_endpoint(path: '/organizations/'),
      @org_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
