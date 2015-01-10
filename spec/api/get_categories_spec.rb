require 'rails_helper'

describe 'GET /categories' do
  before :all do
    @food = Category.create!(name: 'Food', taxonomy_id: '101')
    @emergency = Category.create!(name: 'Emergency', taxonomy_id: '103')
  end

  before :each do
    get api_categories_url(subdomain: ENV['API_SUBDOMAIN'])
  end

  after(:all) do
    Category.find_each(&:destroy)
  end

  it 'displays all categories' do
    expect(json.size).to eq(2)
  end

  it 'returns a 200 status' do
    expect(response).to have_http_status(200)
  end

  it 'includes the id attribute in the serialization' do
    expect(json.first['id']).to eq(@food.id)
  end

  it 'includes the depth attribute in the serialization' do
    expect(json.first['depth']).to eq(@food.depth)
  end

  it 'includes the taxonomy_id attribute in the serialization' do
    expect(json.first['taxonomy_id']).to eq(@food.taxonomy_id)
  end

  it 'includes the name attribute in the serialization' do
    expect(json.first['name']).to eq(@food.name)
  end

  it 'includes the parent_id attribute in the serialization' do
    expect(json.first['parent_id']).to eq(@food.parent_id)
  end
end
