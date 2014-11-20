require 'rails_helper'

describe 'PATCH /locations/:id)' do
  before(:each) do
    @loc = create(:location)
  end

  it 'returns 200 when validations pass' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), name: 'New Name'
    expect(response).to have_http_status(200)
  end

  it 'returns the updated location when validations pass' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), name: 'New Name'
    expect(json['name']).to eq('New Name')
  end

  it 'returns 422 if admin_emails is set to empty string' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), admin_emails: ''
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'][0]['admin_emails']).to eq [' is not a valid email']
  end

  it 'returns 422 if languages is set to empty string' do
    @loc.update!(languages: ['English'])
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']), languages: ''
    expect(@loc.reload.languages).to eq ['English']
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'][0]['languages']).to eq [' is not an Array.']
  end

  it 'sets languages to empty array if value is empty array' do
    @loc.update!(languages: %w(French Arabic))
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

  it 'returns 422 when value is String instead of Array' do
    patch api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
          admin_emails: 'moncef@cfa.com'

    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).
      to eq('Attribute was supposed to be an Array, but was a String.')
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
