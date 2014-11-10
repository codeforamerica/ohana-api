require 'rails_helper'

describe 'POST /locations/:location_id/mail_address' do
  context 'when location does not already have an mail_address' do
    before(:all) do
      @loc = create(:nearby_loc)
    end

    before(:each) do
      @attrs = { street_1: 'foo', city: 'bar', state: 'CA',
                 postal_code: '90210', country_code: 'US' }
    end

    after(:all) do
      Organization.find_each(&:destroy)
    end

    it 'creates an mail_address with valid attributes' do
      post(
        api_location_mail_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response).to have_http_status(201)
      expect(json['street_1']).to eq(@attrs[:street_1])
    end

    it 'creates the mail_address for the right location' do
      post(
        api_location_mail_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['mail_address']['street_1']).to eq(@attrs[:street_1])
    end

    it "doesn't create an mail_address with invalid attributes" do
      post(
        api_location_mail_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
        street_1: nil
      )
      expect(response).to have_http_status(422)
      expect(json['errors'].first['street_1']).
        to eq(["can't be blank for Mail Address"])
    end

    it "doesn't allow creating a mail_address without a valid token" do
      post(
        api_location_mail_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response).to have_http_status(401)
    end
  end

  context 'when location already has a mail_address' do
    before(:each) do
      @loc = create(:no_address)
      @attrs = { street_1: 'foo', city: 'bar', state: 'CA',
                 postal_code: '90210', country_code: 'US' }

      post(
        api_location_mail_address_index_url(@loc, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
    end

    it "doesn't create a new mail_address if one already exists" do
      expect(MailAddress.count).to eq 1
    end

    it "doesn't change the location's current mail_address" do
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['mail_address']['street_1']).to eq 'P.O Box 123'
    end
  end
end
