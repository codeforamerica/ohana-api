require 'rails_helper'

describe 'PATCH /locations/:location_id/services/:id' do
  before(:each) do
    create_service
    @token = ENV['ADMIN_APP_TOKEN']
    @attrs = { name: 'New Service', description: 'Hot Meals' }
  end

  it 'returns 200 when validations pass' do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(200)
  end

  it 'returns the updated service when validations pass' do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(json['name']).to eq 'New Service'
  end

  it "updates the location's service" do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs,
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: "/locations/#{@location.id}")
    expect(json['services'].first['description']).to eq 'Hot Meals'
  end

  it "doesn't add a new service" do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(Service.count).to eq(1)
  end

  it 'requires a valid service id' do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/123"),
      @attrs,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs.merge!(service_areas: ['Belmont, CA']),
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first['service_areas'].first).
      to include('At least one service area is improperly formatted')
  end

  it "doesn't allow updating a service without a valid token" do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      @attrs,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
  end

  it 'updates search index when service changes' do
    patch(
      api_endpoint(path: "/locations/#{@location.id}/services/#{@service.id}"),
      { description: 'fresh tunes for the soul' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: '/search?keyword=yoga')
    expect(headers['X-Total-Count']).to eq '0'
  end
end
