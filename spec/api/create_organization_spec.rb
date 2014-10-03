require 'rails_helper'

describe 'Create an organization (POST /organizations/)' do
  before(:all) do
    create(:organization)
  end

  before(:each) do
    @org_attributes = { name: 'new org', description: 'testing', website: 'http://monfresh.com' }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'creates an organization with valid attributes' do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      @org_attributes
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@org_attributes[:name])
  end

  it 'returns a Location header with the URL to the new organization' do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      @org_attributes
    )
    expect(headers['Location']).
      to eq(api_organization_url('new-org', subdomain: ENV['API_SUBDOMAIN']))
  end

  it "doesn't create an organization with invalid attributes" do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      name: nil
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Organization"])
  end

  it "doesn't allow creating an organization without a valid token" do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      @org_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
