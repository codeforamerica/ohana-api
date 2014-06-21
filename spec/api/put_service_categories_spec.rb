require 'rails_helper'

describe 'PUT /services/:services_id/categories' do
  before(:each) do
    create_service
    @token = ENV['ADMIN_APP_TOKEN']
    @food = Category.create!(name: 'Food', oe_id: '101')
  end

  context 'when the passed in slug exists' do
    it "updates a service's categories" do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { category_slugs: ['food'] },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json['categories'].first['name']).to eq('Food')
    end
  end

  context "when the passed in slug doesn't exist" do
    it 'raises a 404 error' do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { category_slugs: ['health'] },
        'HTTP_X_API_TOKEN' => @token
      )
      @service.reload
      expect(response.status).to eq(404)
      expect(json['message']).to include 'could not be found'
    end
  end

  context 'without a valid token' do
    it 'returns a 401 error' do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { category_slugs: ['food'] },
        'HTTP_X_API_TOKEN' => 'foo'
      )
      expect(response.status).to eq(401)
    end
  end
end
