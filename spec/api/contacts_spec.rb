require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent
  include Features::SessionHelpers

  before(:each) do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  describe 'PATCH /api/locations/:location/contacts/:contact' do
    it "doesn't allow setting non-whitelisted attributes" do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { foo: 'bar' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json).to_not include 'foo'
    end

    it 'allows setting whitelisted attributes' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'Moncef' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json['name']).to eq 'Moncef'
    end

    it "doesn't add a new contact" do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'Moncef' },
        'HTTP_X_API_TOKEN' => @token
      )
      get "api/locations/#{@loc.id}"
      expect(json['contacts'].length).to eq 1
    end

    it 'requires valid contact id' do
      patch(
        "api/locations/#{@loc.id}/contacts/2",
        { name: '', title: 'cfo' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      json['message'].
        should include 'The requested resource could not be found.'
    end

    it 'requires contact name' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: '', title: 'cfo' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include "Name can't be blank"
    end

    it 'requires contact title' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'cfo', title: '' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include "Title can't be blank"
    end

    it 'validates contact phone' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'foo', title: 'cfo', phone: '703' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include '703 is not a valid US phone number'
    end

    it 'validates contact fax' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'foo', title: 'cfo', fax: '703' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include '703 is not a valid US fax number'
    end

    it 'validates contact email' do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'foo', title: 'cfo', email: '703' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(400)
      json['message'].should include '703 is not a valid email'
    end

    it "doesn't allow updating a contact witout a valid token" do
      patch(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        { name: 'foo', title: 'cfo' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE /api/locations/:location/contacts/:contact' do
    it 'deletes the contact' do
      delete(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        {},
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json).to_not include 'contacts'
    end

    it "doesn't allow deleting a contact witout a valid token" do
      delete(
        "api/locations/#{@loc.id}/contacts/#{@contact.id}",
        {},
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end

  describe 'POST /api/locations/:location/contacts' do
    it 'creates a second contact for the specified location' do
      post(
        "api/locations/#{@loc.id}/contacts",
        { name: 'foo', title: 'cfo' },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json['contacts'].length).to eq 2
      expect(json['contacts'][1]['name']).to eq 'foo'
    end

    it "doesn't allow creating a contact witout a valid token" do
      post(
        "api/locations/#{@loc.id}/contacts",
        { name: 'foo', title: 'cfo' },
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
