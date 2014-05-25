require 'spec_helper'

describe Ohana::API do

  describe 'Category Requests' do
    include DefaultUserAgent

    describe 'GET /api/categories/:category_id/children' do
      context 'when category has children' do
        before :each do
          @food = Category.create!(name: 'Food', oe_id: '101')
          @food_child = @food.children.
            create!(name: 'Emergency Food', oe_id: '101-01')
          get "/api/categories/#{@food.id}/children"
        end

        it "returns the category's children" do
          represented = [{
            'id'    => @food_child.id,
            'depth' => @food_child.depth,
            'oe_id' => '101-01',
            'name'  => 'Emergency Food',
            'parent_id' => @food_child.parent_id,
            'slug' => 'emergency-food'
          }]
          json.should == represented
        end

        it 'is json' do
          response.content_type.should == 'application/json'
        end

        it 'returns a successful status code' do
          expect(response).to be_success
        end
      end

      context "when category doesn't have children" do
        before :each do
          @food = Category.create!(name: 'Food', oe_id: '101')
          get "/api/categories/#{@food.id}/children"
        end

        it 'returns an empty array' do
          json.should == []
        end

        it 'is json' do
          response.content_type.should == 'application/json'
        end

        it 'returns a successful status code' do
          expect(response).to be_success
        end
      end
    end

    describe 'GET /api/categories' do
      before :each do
        @food = Category.create!(name: 'Food', oe_id: '101')
        @food.update_attributes!(name: 'Emergency Food')
      end

      it "displays the category's latest slug" do
        get '/api/categories'
        represented = [{
          'id'    => @food.id,
          'depth' => 0,
          'oe_id' => '101',
          'name'  => 'Emergency Food',
          'parent_id' => nil,
          'slug' => 'emergency-food'
        }]
        json.should == represented
      end

      it 'is accessible by its old slug' do
        @food.children.create!(name: 'Community Gardens', oe_id: '101-01')
        get '/api/categories/food/children'
        expect(json.first['name']).to eq('Community Gardens')
      end
    end
  end
end
