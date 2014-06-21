require 'rails_helper'

describe 'PATCH contact' do
  before(:each) do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
    @token = ENV['ADMIN_APP_TOKEN']
    @attrs = { name: 'Moncef', title: 'Consultant', email: 'bar@foo.com' }
  end

  describe 'PATCH /locations/:location_id/contacts/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated contact when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(json['title']).to eq 'Consultant'
    end

    it "updates the location's contact" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['contacts'].first['email']).to eq 'bar@foo.com'
    end

    it "doesn't add a new contact" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(Contact.count).to eq(1)
    end

    it 'requires a valid contact id' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/123"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs.merge!(name: ''),
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('name' => ["can't be blank for Contact"])
    end

    it "doesn't allow updating a contact without a valid token" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
