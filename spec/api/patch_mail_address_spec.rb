require 'rails_helper'

describe 'PATCH mail_address' do
  before(:each) do
    @mail_address = create(:mail_address)
    @loc = @mail_address.location
    @attrs = { street_1: 'foo', city: 'bar', state: 'CA', postal_code: '90210',
               country_code: 'US' }
  end

  describe 'PATCH /locations/:location/mail_address' do
    it 'returns 200 when validations pass' do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated mail_address when validations pass' do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(json['city']).to eq 'bar'
    end

    it "updates the location's mail_address" do
      patch(
        api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['mail_address']['street_1']).to eq 'foo'
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
        @attrs.merge!(street_1: '')
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('street_1' => ["can't be blank for Mail Address"])
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
