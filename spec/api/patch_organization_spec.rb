require 'rails_helper'

describe 'PATCH /organizations/:id' do
  before(:all) do
    loc_with_org = create(:location)
    @org = loc_with_org.organization
  end

  before(:each) do
    @org.reload
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'returns 200 when validations pass' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      name: 'New Name'
    )
    expect(response).to have_http_status(200)
  end

  it 'returns the updated organization when validations pass' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      name: 'New Name'
    )
    expect(json['name']).to eq('New Name')
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      website: 'monfresh.com'
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first).
      to eq('website' => ['monfresh.com is not a valid URL'])
  end

  it 'returns 422 when required attribute is missing' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      name: nil
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first).
      to eq('name' => ["can't be blank for Organization"])
  end

  it 'returns 404 when id is missing' do
    patch(
      api_organizations_url(subdomain: ENV['API_SUBDOMAIN']),
      description: ''
    )
    expect(response.status).to eq(404)
    expect(json['message']).to eq('The requested resource could not be found.')
    expect(json['documentation_url']).
      to eq('http://codeforamerica.github.io/ohana-api-docs/')
  end

  it 'updates the search index when organization name changes' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      name: 'Code for America'
    )
    get api_search_index_url(keyword: 'america', subdomain: ENV['API_SUBDOMAIN'])
    expect(json.first['organization']['name']).to eq('Code for America')
  end

  it "doesn't allow updating an organization without a valid token" do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      { name: 'new name' },
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end

  it 'is accessible by its old slug' do
    patch(
      api_organization_url(@org, subdomain: ENV['API_SUBDOMAIN']),
      name: 'new name'
    )
    get api_organization_url('parent-agency', subdomain: ENV['API_SUBDOMAIN'])
    json = JSON.parse(response.body)
    expect(json['name']).to eq('new name')
  end
end
