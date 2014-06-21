require 'rails_helper'

describe 'POST /locations/:location_id/contacts' do
  before(:each) do
    @loc = create(:location)
    @token = ENV['ADMIN_APP_TOKEN']
    @contact_attributes = { name: 'Moncef', title: 'Consultant' }
  end

  it 'creates a contact with valid attributes' do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/contacts"),
      @contact_attributes,
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(201)
    expect(json['name']).to eq(@contact_attributes[:name])
  end

  it "doesn't create a contact with invalid attributes" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/contacts"),
      { email: 'belmont' },
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['email']).to eq(['belmont is not a valid email'])
  end

  it "doesn't allow creating a contact without a valid token" do
    post(
      api_endpoint(path: "/locations/#{@loc.id}/contacts"),
      @contact_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end

  it 'creates a second contact for the specified location' do
    @loc.contacts.create!(@contact_attributes)
    post(
      api_endpoint(path: "/locations/#{@loc.id}/contacts"),
      { name: 'foo', title: 'cfo' },
      'HTTP_X_API_TOKEN' => @token
    )
    get api_endpoint(path: "/locations/#{@loc.id}")
    expect(json['contacts'].length).to eq 2
    expect(json['contacts'][1]['name']).to eq 'foo'
  end
end
