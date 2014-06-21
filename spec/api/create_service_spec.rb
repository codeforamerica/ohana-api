require 'rails_helper'

describe 'POST /locations/:location_id/services' do
  before(:each) do
    @loc = create(:location)
    @service_attributes = {
      fees: 'new fees',
      audience: 'new audience',
      keywords: %w(food youth)
    }
  end

  it 'creates a service with valid attributes' do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/services"),
      @service_attributes,
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(201)
    expect(json['fees']).to eq(@service_attributes[:fees])
  end

  it "doesn't create a service with invalid attributes" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/services"),
      { urls: ['belmont'] },
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['urls']).to eq(['belmont is not a valid URL'])
  end

  it "doesn't allow creating a service without a valid token" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/services"),
      @service_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
