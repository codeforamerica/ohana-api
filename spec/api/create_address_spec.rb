require 'rails_helper'

describe 'POST /locations/:location_id/address' do
  context 'when location does not already have an address' do
    before(:each) do
      @loc = create(:no_address)
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }
    end

    it 'creates an address with valid attributes' do
      post api_location_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
           @attrs

      expect(response).to have_http_status(201)
      expect(json['street']).to eq(@attrs[:street])
    end

    it 'creates the address for the right location' do
      post api_location_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
           @attrs

      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['address']['street']).to eq(@attrs[:street])
    end

    it "doesn't create an address with invalid attributes" do
      post api_location_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
           street: nil

      expect(response).to have_http_status(422)
      expect(json['errors'].first['street']).
        to eq(["can't be blank for Address"])
    end

    it "doesn't allow creating a address without a valid token" do
      post(
        api_location_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
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
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }

      post api_location_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
           @attrs
    end

    it "doesn't create a new address if one already exists" do
      expect(Address.count).to eq 1
    end

    it "does not change the location's current address" do
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['address']['street']).to eq '1800 Easton Drive'
    end
  end
end
