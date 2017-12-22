require 'rails_helper'

describe 'PUT /services/:service_id/categories' do
  before(:all) do
    create_service
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'returns 200 when validations pass' do
    create(:category)
    create(:health)
    put(
      api_service_categories_url(@service, subdomain: ENV['API_SUBDOMAIN']),
      taxonomy_ids: %w[101 102]
    )

    expect(response).to have_http_status(200)
    expect(json['categories'][0]['name']).to eq 'Food'
    expect(json['categories'][1]['name']).to eq 'Health'
  end
end
