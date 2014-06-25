require 'rails_helper'

describe 'POST /locations/:location_id/address' do
  context 'when location does not already have an address' do
    before(:each) do
      @loc = create(:no_address)
      @token = ENV['ADMIN_APP_TOKEN']
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }
    end

    it 'creates an address with valid attributes' do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(201)
      expect(json['street']).to eq(@attrs[:street])
    end

    it 'creates the address for the right location' do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['address']['street']).to eq(@attrs[:street])
    end

    it "doesn't create an address with invalid attributes" do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/address"),
        { street: nil },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(422)
      expect(json['errors'].first['street']).
        to eq(["can't be blank for Address"])
    end

    it "doesn't allow creating a address without a valid token" do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/address"),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response).to have_http_status(401)
    end
  end

  context 'when location already has an address' do
    before(:each) do
      @loc = create(:location)
      @address = @loc.address
      @token = ENV['ADMIN_APP_TOKEN']
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }

      post(
        api_endpoint(path: "/locations/#{@loc.id}/address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
    end

    it "doesn't create a new address if one already exists" do
      expect(Address.count).to eq 1
    end

    it "does not change the location's current address" do
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['address']['street']).to eq '1800 Easton Drive'
    end
  end
end
