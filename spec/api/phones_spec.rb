require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent
  include Features::SessionHelpers

  before(:each) do
    @loc = create(:location)
    @phone = @loc.phones.create!(attributes_for(:phone))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  describe 'PATCH /api/locations/:location/phones/:phone' do
    it "doesn't allow setting non-whitelisted attributes" do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { foo: 'bar' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json).to_not include 'foo'
    end

    it 'allows setting whitelisted attributes' do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { number: '703-555-1212' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json['number']).to eq '703-555-1212'
    end

    it "doesn't add a new phone" do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { number: '800-222-3333' },
        'HTTP_X_API_TOKEN' => @token
      )
      get "api/locations/#{@loc.id}"
      expect(json['phones'].length).to eq 1
    end

    it 'requires valid phone id' do
      patch(
        "api/locations/#{@loc.id}/phones/2014",
        { number: '800-555-1212', department: 'Youth Development' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'requires phone number' do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { number: '', department: 'foo' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      expect(json['message']).to include "Number can't be blank"
    end

    it 'validates phone number' do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { number: '703' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      expect(json['message']).to include '703 is not a valid US phone number'
    end

    it "doesn't allow updating a phone witout a valid token" do
      patch(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        { number: '800-555-1212' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE /api/locations/:location/phones/:phone' do
    it 'deletes the phone' do
      delete(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        {},
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json).to_not include 'phones'
    end

    it "doesn't allow deleting a phone witout a valid token" do
      delete(
        "api/locations/#{@loc.id}/phones/#{@phone.id}",
        {},
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'POST /api/locations/:location/phones' do
    it 'creates a second phone for the specified location' do
      post(
        "api/locations/#{@loc.id}/phones",
        { number: '708-222-5555' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json['phones'].length).to eq 2
      expect(json['phones'][1]['number']).to eq '708-222-5555'
    end

    it "doesn't allow creating a phone witout a valid token" do
      post(
        "api/locations/#{@loc.id}/phones",
        { number: '800-123-4567' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
