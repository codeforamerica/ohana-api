require 'rails_helper'

describe 'PATCH /locations/:id)' do
  before(:each) do
    @loc = create(:location)
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'returns 200 when validations pass' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(200)
  end

  it 'returns the updated location when validations pass' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(json['name']).to eq('New Name')
  end

  it 'returns a Location header with the URL to the updated location' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'New Name' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(headers['Location']).to eq("#{api_endpoint}/locations/#{@loc.reload.slug}")
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { admin_emails: ['moncef-at-ohanapi.org'] },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first).
      to eq('admin_emails' => ['moncef-at-ohanapi.org is not a valid email'])
  end

  it 'returns 422 when value is String instead of Array' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { emails: 'moncef@cfa.com' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).
      to eq('Attribute was supposed to be an Array, but was a String: "moncef@cfa.com".')
  end

  it 'returns 422 when required attribute is missing' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { description: '' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first).
      to eq('description' => ["can't be blank for Location"])
  end

  it 'returns 404 when id is missing' do
    patch(
      api_endpoint(path: '/locations/'),
      { description: '' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(404)
    expect(json['message']).to eq('The requested resource could not be found.')
  end

  it 'updates the search index when location changes' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'changeme' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: '/search?keyword=changeme')
    expect(json.first['name']).to eq('changeme')
  end
end

describe 'Update a location without a valid token' do
  it "doesn't allow updating a location without a valid token" do
    @loc = create(:location)
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'new name' },
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end

describe "Update a location's slug" do
  before(:each) do
    @loc = create(:location)
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'is accessible by its old slug' do
    patch(
      api_endpoint(path: "/locations/#{@loc.id}"),
      { name: 'new name' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: '/locations/vrs-services')
    json = JSON.parse(response.body)
    expect(json['name']).to eq('new name')
  end
end
