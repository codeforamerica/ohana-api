require 'rails_helper'

describe 'PATCH phone' do
  before(:each) do
    @loc = create(:location)
    @phone = @loc.phones.create!(attributes_for(:phone))
    @token = ENV['ADMIN_APP_TOKEN']
    @attrs = { number: '123-456-7890', department: 'Director' }
  end

  describe 'PATCH /locations/:location_id/phones/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated phone when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(json['department']).to eq 'Director'
    end

    it "updates the location's phone" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['phones'].first['number']).to eq '123-456-7890'
    end

    it "doesn't add a new phone" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(Phone.count).to eq(1)
    end

    it 'requires a valid phone id' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/123"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs.merge!(number: '703'),
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('number' => ['703 is not a valid US phone number'])
    end

    it "doesn't allow updating a phone without a valid token" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
