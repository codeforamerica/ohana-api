require 'rails_helper'

describe 'GET /categories/:category_id/children' do
  context 'when category has children' do
    before :each do
      @food = Category.create!(name: 'Food', oe_id: '101')
      @food_child = @food.children.
        create!(name: 'Emergency Food', oe_id: '101-01')
      get api_endpoint(path: "/categories/#{@food.id}/children")
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'includes the id attribute in the serialization' do
      expect(json.first['id']).to eq(@food_child.id)
    end

    it 'includes the depth attribute in the serialization' do
      expect(json.first['depth']).to eq(@food_child.depth)
    end

    it 'includes the oe_id attribute in the serialization' do
      expect(json.first['oe_id']).to eq(@food_child.oe_id)
    end

    it 'includes the name attribute in the serialization' do
      expect(json.first['name']).to eq(@food_child.name)
    end

    it 'includes the parent_id attribute in the serialization' do
      expect(json.first['parent_id']).to eq(@food_child.parent_id)
    end

    it 'includes the slug attribute in the serialization' do
      expect(json.first['slug']).to eq(@food_child.slug)
    end
  end

  context "when category doesn't have children" do
    before :each do
      @food = Category.create!(name: 'Food', oe_id: '101')
      get api_endpoint(path: "/categories/#{@food.id}/children")
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
