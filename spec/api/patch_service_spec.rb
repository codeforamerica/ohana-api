require 'rails_helper'

describe 'PATCH /locations/:location_id/services/:id' do
  before(:all) do
    create_service
  end

  before(:each) do
    @attrs = { name: 'New Service', description: 'Hot Meals',
               how_to_apply: 'Walk in.' }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'returns 200 when validations pass' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(response).to have_http_status(200)
  end

  it 'returns the updated service when validations pass' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(json['name']).to eq 'New Service'
  end

  it "updates the location's service" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])
    expect(json['services'].first['description']).to eq 'Hot Meals'
  end

  it "doesn't add a new service" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(Service.count).to eq(1)
  end

  it 'requires a valid service id' do
    patch(
      api_location_service_url(@location, 123, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(response.status).to eq(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(service_areas: ['Belmont, CA'])
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first['service_areas'].first).
      to eq('Belmont, CA is not a valid service area')
  end

  it 'returns 422 when service_areas is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(service_areas: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).to include('Attribute was supposed to be an Array')
  end

  it 'returns 422 when funding_sources is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(funding_sources: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).to include('Attribute was supposed to be an Array')
  end

  it 'returns 422 when keywords is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(keywords: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['error']).to include('Attribute was supposed to be an Array')
  end

  it 'returns 422 when languages is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(languages: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'][0]['languages']).to eq [' is not an Array.']
  end

  it 'returns 422 when accepted_payments is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(accepted_payments: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'][0]['accepted_payments']).to eq [' is not an Array.']
  end

  it 'returns 422 when required_documents is empty String' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(required_documents: '')
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'][0]['required_documents']).to eq [' is not an Array.']
  end

  it "doesn't allow updating a service without a valid token" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
  end

  it 'updates search index when service changes' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      description: 'fresh tunes for the soul'
    )
    get api_search_index_url(keyword: 'yoga', subdomain: ENV['API_SUBDOMAIN'])
    expect(headers['X-Total-Count']).to eq '0'
  end
end
