require 'rails_helper'

describe 'POST /locations/:location_id/mail_address' do
  context 'when location does not already have an mail_address' do
    before(:each) do
      @loc = create(:nearby_loc)
      @token = ENV['ADMIN_APP_TOKEN']
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }
    end

    it 'creates an mail_address with valid attributes' do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/mail_address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(201)
      expect(json['street']).to eq(@attrs[:street])
    end

    it 'creates the mail_address for the right location' do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/mail_address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['mail_address']['street']).to eq(@attrs[:street])
    end

    it "doesn't create an mail_address with invalid attributes" do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/mail_address"),
        { street: nil },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(422)
      expect(json['errors'].first['street']).
        to eq(["can't be blank for Mail Address"])
    end

    it "doesn't allow creating a mail_address without a valid token" do
      post(
        api_endpoint(path: "/locations/#{@loc.id}/mail_address"),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response).to have_http_status(401)
    end
  end

  context 'when location already has a mail_address' do
    before(:each) do
      @loc = create(:no_address)
      @mail_address = @loc.mail_address
      @token = ENV['ADMIN_APP_TOKEN']
      @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }

      post(
        api_endpoint(path: "/locations/#{@loc.id}/mail_address"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
    end

    it "doesn't create a new mail_address if one already exists" do
      expect(MailAddress.count).to eq 1
    end

    it "doesn't change the location's current mail_address" do
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['mail_address']['street']).to eq 'P.O Box 123'
    end
  end
end
