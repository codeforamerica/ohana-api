require 'rails_helper'

describe 'PATCH /organizations/:id' do
  before(:each) do
    loc_with_org = create(:location)
    @org = loc_with_org.organization
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'returns 200 when validations pass' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(200)
  end

  it 'returns the updated organization when validations pass' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(json['name']).to eq('New Name')
  end

  it 'returns a Location header with the URL to the updated organization' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(headers['Location']).
      to eq("#{api_endpoint}/organizations/#{@org.reload.slug}")
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { urls: ['monfresh.com'] },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first).
      to eq('urls' => ['monfresh.com is not a valid URL'])
  end

  it 'returns 422 when value is String instead of Array' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { urls: 'http://monfresh.com' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).
      to eq('Attribute was supposed to be an Array, but was a String: "http://monfresh.com".')
  end

  it 'returns 422 when required attribute is missing' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: nil },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first).
      to eq('name' => ["can't be blank for Organization"])
  end

  it 'returns 404 when id is missing' do
    patch(
      api_endpoint(path: '/organizations/'),
      { description: '' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(404)
    expect(json['message']).to eq('The requested resource could not be found.')
    expect(json['documentation_url']).to eq("#{docs_endpoint}")
  end

  it 'updates the search index when organization changes' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'Code for America' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: '/search?keyword=america')
    expect(json.first['organization']['name']).to eq('Code for America')
  end
end

describe 'Update a organization without a valid token' do
  it "doesn't allow updating an organization without a valid token" do
    @org = create(:organization)
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'new name' },
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end

describe "Update an organization's slug" do
  before(:each) do
    @org = create(:organization)
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'is accessible by its old slug' do
    patch(
      api_endpoint(path: "/organizations/#{@org.id}"),
      { name: 'new name' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: '/organizations/parent-agency')
    json = JSON.parse(response.body)
    expect(json['name']).to eq('new name')
  end
end
