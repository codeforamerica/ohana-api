require 'rails_helper'

describe 'PATCH address' do
  before(:each) do
    @loc = create(:location)
    @address = @loc.address
    @attrs = { street_1: '1236 Broadway', city: 'Burlingame', state: 'CA',
               postal_code: '94010', country_code: 'US' }
  end

  describe 'PATCH /locations/:location_id/address/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated address when validations pass' do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(json['city']).to eq 'Burlingame'
    end

    it "updates the location's address" do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['address']['street_1']).to eq '1236 Broadway'
    end

    it "updates the location's coordinates when the address has changed" do
      old_coords = [@loc.longitude, @loc.latitude]
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(@loc.reload.longitude).to_not eq old_coords.first
    end

    it "doesn't update location's coordinates when address hasn't changed" do
      old_coords = [@loc.longitude, @loc.latitude]
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs.merge!(street_1: '1800 Easton Drive')
      )
      expect(@loc.reload.longitude).to eq old_coords.first
    end

    it "doesn't add a new address" do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(Address.count).to eq(1)
    end

    it 'requires a valid address id' do
      patch(
        api_location_address_url(@loc, 1234, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs.merge!(street_1: '')
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('address.street_1' => ["can't be blank for Address"])
    end

    it "doesn't allow updating a address without a valid token" do
      patch(
        api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
