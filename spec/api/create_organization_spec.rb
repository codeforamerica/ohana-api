require 'rails_helper'

describe 'Create an organization (POST /organizations/)' do
  before(:all) do
    create(:organization)
  end

  before do
    @org_attributes = {
      accreditations: ['BBB', 'State Board of Education'],
      alternate_name: 'Alternate Name',
      date_incorporated: 'January 01, 1970',
      description: 'description',
      email: 'org@test.com',
      funding_sources: %w[State Donations Grants],
      legal_status: 'non-profit',
      licenses: ['State Health Inspection License'],
      name: 'New Org',
      tax_id: '123-abc',
      tax_status: '501(c)(3)',
      website: 'https://foo.org'
    }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'creates an organization with valid attributes' do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      organization: @org_attributes
    )
    expect(response.status).to eq(201)
    expect(json['accreditations']).to eq(@org_attributes[:accreditations])
    expect(json['alternate_name']).to eq(@org_attributes[:alternate_name])
    expect(json['date_incorporated']).to eq('1970-01-01')
    expect(json['description']).to eq(@org_attributes[:description])
    expect(json['email']).to eq(@org_attributes[:email])
    expect(json['funding_sources']).to eq(@org_attributes[:funding_sources])
    expect(json['licenses']).to eq(@org_attributes[:licenses])
    expect(json['name']).to eq(@org_attributes[:name])
    expect(json['website']).to eq(@org_attributes[:website])
  end

  it 'returns a Location header with the URL to the new organization' do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      organization: @org_attributes
    )
    expect(headers['Location']).
      to eq(api_organization_url('new-org', subdomain: ENV['API_SUBDOMAIN']))
  end

  it "doesn't create an organization with invalid attributes" do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      organization: { name: nil }
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['name']).to eq(["can't be blank for Organization"])
  end

  it "doesn't allow creating an organization without a valid token" do
    post(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      { organization: @org_attributes },
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
