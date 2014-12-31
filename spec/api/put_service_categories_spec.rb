require 'rails_helper'

describe 'PUT /services/:service_id/categories' do
  before(:all) do
    create_service
    @food = Category.create!(name: 'Food', taxonomy_id: '101')
  end

  after(:all) do
    Organization.find_each(&:destroy)
    Category.find_each(&:destroy)
  end

  context 'when the passed in taxonomy_id exists' do
    it "updates a service's categories" do
      put(
        api_service_categories_url(@service, subdomain: ENV['API_SUBDOMAIN']),
        taxonomy_ids: ['101']
      )
      expect(response).to be_success
      expect(json['categories'].first['name']).to eq('Food')
    end
  end

  context "when the passed in taxonomy_id doesn't exist" do
    it 'ignores it' do
      put(
        api_service_categories_url(@service, subdomain: ENV['API_SUBDOMAIN']),
        taxonomy_ids: ['102']
      )
      expect(response.status).to eq(200)
      expect(json['categories']).to eq([])
    end
  end

  context 'without a valid token' do
    it 'returns a 401 error' do
      put(
        api_service_categories_url(@service, subdomain: ENV['API_SUBDOMAIN']),
        { taxonomy_ids: ['101'] },
        'HTTP_X_API_TOKEN' => 'foo'
      )
      expect(response.status).to eq(401)
    end
  end
end
