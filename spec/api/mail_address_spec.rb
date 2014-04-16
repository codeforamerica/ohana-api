require 'spec_helper'

describe Ohana::API do
  include DefaultUserAgent
  include Features::SessionHelpers

  before(:each) do
    @loc = create(:location)
    @mail_address = @loc.create_mail_address!(attributes_for(:mail_address))
    @token = ENV["ADMIN_APP_TOKEN"]
    @attrs = { street: "foo", city: "bar", state: "CA", zip: "90210" }
  end

  describe "PATCH /api/locations/:location/mail_address" do
    it "doesn't allow setting non-whitelisted attributes" do
      patch "api/locations/#{@loc.id}/mail_address",
        { :foo => "bar" },
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response).to be_success
      expect(json).to_not include "foo"
    end

    it "allows setting whitelisted attributes" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response).to be_success
      expect(json["city"]).to eq "bar"
    end

    it "doesn't add a new mail_address" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => @token }
      get "api/locations/#{@loc.id}"
      expect(json["mail_address"]["street"]).to eq "foo"
    end

    it "requires valid location id" do
      patch "api/locations/2/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(404)
      json["message"].
        should include "The requested resource could not be found."
    end

    it "requires mail_address street" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(street: ""),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      json["message"].should include "Street can't be blank for Mail Address"
    end

    it "requires mail_address city" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(city: ""),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      json["message"].should include "City can't be blank for Mail Address"
    end

    it "requires mail_address state" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(state: ""),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      json["message"].should include "State can't be blank for Mail Address"
    end

    it "requires mail_address zip" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(zip: ""),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      json["message"].should include "Zip can't be blank for Mail Address"
    end

    it "validates length of state" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(state: "C"),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      expect(json["message"])
        .to include "Please enter a valid 2-letter state abbreviation"
    end

    it "validates zip format" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs.merge!(zip: "901"),
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response.status).to eq(400)
      json["message"].should include "901 is not a valid ZIP code"
    end

    it "doesn't allow updating a mail_address witout a valid token" do
      patch "api/locations/#{@loc.id}/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => "invalid_token" }
      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /api/locations/:location/mail_address" do
    it "deletes the mail_address" do
      delete "api/locations/#{@loc.id}/mail_address",
        {},
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json).to_not include "mail_address"
    end

    it "doesn't allow deleting a mail_address witout a valid token" do
      delete "api/locations/#{@loc.id}/mail_address",
        {},
        { 'HTTP_X_API_TOKEN' => "invalid_token" }
      expect(response.status).to eq(401)
    end

    it "doesn't delete the mail_address if an address isn't present" do
      delete "api/locations/#{@loc.id}/address",
        {},
        { 'HTTP_X_API_TOKEN' => @token }

      delete "api/locations/#{@loc.id}/mail_address",
        {},
        { 'HTTP_X_API_TOKEN' => @token }

      expect(json["error"]).
        to eq "A location must have at least one address type."
    end
  end

  describe "POST /api/locations/:location/mail_address" do
    it "replaces the mail_address for the specified location" do
      post "api/locations/#{@loc.id}/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => @token }
      expect(response).to be_success
      get "api/locations/#{@loc.id}"
      expect(json["mail_address"]["street"]).to eq "foo"
    end

    it "doesn't allow creating a mail_address witout a valid token" do
      post "api/locations/#{@loc.id}/mail_address",
        @attrs,
        { 'HTTP_X_API_TOKEN' => "invalid_token" }
      expect(response.status).to eq(401)
    end
  end
end