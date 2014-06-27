require 'rails_helper'

describe 'POST /locations/:location_id/faxes' do
  before(:each) do
    @loc = create(:location)
    @token = ENV['ADMIN_APP_TOKEN']
    @fax_attributes = { number: '123-456-7890' }
  end

  it 'creates a fax with valid attributes' do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/faxes"),
      @fax_attributes,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(201)
    expect(json['number']).to eq(@fax_attributes[:number])
  end

  it "doesn't create a fax with invalid attributes" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/faxes"),
      { number: '703' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['number']).
      to eq(['703 is not a valid US fax number'])
  end

  it "doesn't allow creating a fax without a valid token" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/faxes"),
      @fax_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end

  it 'creates a second fax for the specified location' do
    @loc.faxes.create!(@fax_attributes)
    post(
      api_endpoint(path: "/locations/#{@loc.id}/faxes"),
      { number: '789-456-1234', department: 'cfo' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: "/locations/#{@loc.id}")
    expect(json['faxes'].length).to eq 2
    expect(json['faxes'][1]['department']).to eq 'cfo'
  end
end
