require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent
  include Features::SessionHelpers

  before(:each) do
    @loc = create(:location)
    @fax = @loc.faxes.create!(attributes_for(:fax))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  describe 'PATCH /api/locations/:location/faxes/:fax' do
    it "doesn't allow setting non-whitelisted attributes" do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { foo: 'bar' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json).to_not include 'foo'
    end

    it 'allows setting whitelisted attributes' do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { number: '703-555-1212' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json['number']).to eq '703-555-1212'
    end

    it "doesn't add a new fax" do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { number: '800-222-3333' },
        'HTTP_X_API_TOKEN' => @token
      )
      get "api/locations/#{@loc.id}"
      expect(json['faxes'].length).to eq 1
    end

    it 'requires valid fax id' do
      patch(
        "api/locations/#{@loc.id}/faxes/2014",
        { number: '800-555-1212', department: 'Youth Development' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      json['message'].
        should include 'The requested resource could not be found.'
    end

    it 'requires fax number' do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { number: '', department: 'foo' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include "Number can't be blank"
    end

    it 'validates fax number' do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { number: '703' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include '703 is not a valid US fax number'
    end

    it "doesn't allow updating a fax witout a valid token" do
      patch(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        { number: '800-555-1212' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE /api/locations/:location/faxes/:fax' do
    it 'deletes the fax' do
      delete(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        {},
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json).to_not include 'faxes'
    end

    it "doesn't allow deleting a fax witout a valid token" do
      delete(
        "api/locations/#{@loc.id}/faxes/#{@fax.id}",
        {},
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'POST /api/locations/:location/faxes' do
    it 'creates a second fax for the specified location' do
      post(
        "api/locations/#{@loc.id}/faxes",
        { number: '708-222-5555' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json['faxes'].length).to eq 2
      expect(json['faxes'][1]['number']).to eq '708-222-5555'
    end

    it "doesn't allow creating a fax witout a valid token" do
      post(
        "api/locations/#{@loc.id}/faxes",
        { number: '800-123-4567' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
