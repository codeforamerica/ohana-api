require 'rails_helper'

describe 'PATCH mail_address' do
  before(:each) do
    @mail_address = create(:mail_address)
    @loc = @mail_address.location
    @attrs = {
      attention: 'Jane Doe',
      address_1: 'foo',
      address_2: 'apt 101',
      city: 'bar',
      state_province: 'CA',
      postal_code: '90210',
      country: 'US'
    }
  end

  describe 'PATCH /locations/:location/mail_address' do
    it 'returns 200 when validations pass' do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response).to have_http_status(200)
      expect(json['attention']).to eq @attrs[:attention]
      expect(json['address_1']).to eq @attrs[:address_1]
      expect(json['address_2']).to eq @attrs[:address_2]
      expect(json['city']).to eq @attrs[:city]
      expect(json['state_province']).to eq @attrs[:state_province]
      expect(json['postal_code']).to eq @attrs[:postal_code]
    end

    it "updates the location's mail_address" do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['mail_address']['address_1']).to eq 'foo'
    end

    it "doesn't add a new mail_address" do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(MailAddress.count).to eq(1)
    end

    it 'requires a valid mail_address id' do
      patch(
        api_location_mail_address_url(@loc, 123, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs.merge!(address_1: '')
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('address_1' => ["can't be blank for Mail Address"])
    end

    it "doesn't allow updating a mail_address without a valid token" do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
