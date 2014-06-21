require 'rails_helper'

describe 'POST /locations/:location_id/phones' do
  before(:each) do
    @loc = create(:location)
    @token = ENV['ADMIN_APP_TOKEN']
    @phone_attributes = { number: '123-456-7890' }
  end

  it 'creates a phone with valid attributes' do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/phones"),
      @phone_attributes,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(201)
    expect(json['number']).to eq(@phone_attributes[:number])
  end

  it "doesn't create a phone with invalid attributes" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/phones"),
      { number: '703' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['number']).
      to eq(['703 is not a valid US phone number'])
  end

  it "doesn't allow creating a phone without a valid token" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/phones"),
      @phone_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end

  it 'creates a second phone for the specified location' do
    @loc.phones.create!(@phone_attributes)
    post(
      api_endpoint(path: "/locations/#{@loc.id}/phones"),
      { number: '789-456-1234', department: 'cfo' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: "/locations/#{@loc.id}")
    expect(json['phones'].length).to eq 2
    expect(json['phones'][1]['department']).to eq 'cfo'
  end
end
