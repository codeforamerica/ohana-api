require 'rails_helper'

describe 'DELETE /locations/:location_id/services/:id' do
  before :all do
    create_service
  end

  before :each do
    delete api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']), {}
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'returns a 204 status' do
    expect(response).to have_http_status(204)
  end

  it 'deletes the service' do
    expect(@location.reload.services.count).to eq(0)
    expect(Service.count).to eq(0)
  end

  it 'updates the search index' do
    get api_search_index_url(keyword: 'yoga', subdomain: ENV['API_SUBDOMAIN'])
    expect(json.size).to eq(0)
  end
end

describe 'with an invalid token' do
  before :each do
    create_service
    delete(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      {},
      'HTTP_X_API_TOKEN' => 'foo'
    )
  end

  it "doesn't allow deleting a location without a valid token" do
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
