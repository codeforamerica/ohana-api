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
          expect(json).to eq(represented)
        end

        it 'is json' do
          expect(response.content_type).to eq('application/json')
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
          expect(json).to eq([])
        end

        it 'is json' do
          expect(response.content_type).to eq('application/json')
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
        expect(json).to eq(represented)
      end

      it 'is accessible by its old slug' do
        @food.children.create!(name: 'Community Gardens', oe_id: '101-01')
        get '/api/categories/food/children'
        expect(json.first['name']).to eq('Community Gardens')
      end
    end

    describe 'order categories by oe_id' do
      include Features::SessionHelpers

      before :each do
        @food = Category.create!(name: 'Food', oe_id: '101')
        @food_child = @food.children.
          create!(name: 'Community Gardens', oe_id: '101-01')
        @dental = Category.create!(name: 'Dental', oe_id: '102')
        @dental_child = @dental.children.
          create!(name: 'Orthodontics', oe_id: '102-01')
        create_service
        cat_ids = []
        [@food, @food_child, @dental, @dental_child].each do |cat|
          cat_ids.push(cat.id)
        end
        @service.category_ids = cat_ids
      end

      it 'orders the categories by oe_id' do
        get "api/locations/#{@location.id}"

        path = "#{ENV['API_BASE_URL']}organizations"

        service_formatted_time = @location.services.first.updated_at.
          strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

        location_formatted_time = @location.updated_at.
          strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

        locations_url = "#{path}/#{@location.organization.id}/locations"

        represented = {
          'id' => @location.id,
          'accessibility' => @location.accessibility.map(&:text),
          'address' => {
            'id'     => @location.address.id,
            'street' => @location.address.street,
            'city'   => @location.address.city,
            'state'  => @location.address.state,
            'zip'    => @location.address.zip
          },
          'coordinates' => @location.coordinates,
          'description' => @location.description,
          'latitude' => @location.latitude,
          'longitude' => @location.longitude,
          'name' => @location.name,
          'short_desc' => 'short description',
          'slug' => 'vrs-services',
          'updated_at' => location_formatted_time,
          'url' => "#{ENV['API_BASE_URL']}locations/#{@location.id}",
          'services' => [{
            'id' => @location.services.reload.first.id,
            'description' => @location.services.first.description,
            'keywords' => @location.services.first.keywords,
            'categories' => [
              {
                'id'    => @food.id,
                'depth' => 0,
                'oe_id' => '101',
                'name'  => 'Food',
                'parent_id' => nil,
                'slug' => 'food'
              },
              {
                'id'    => @food_child.id,
                'depth' => 1,
                'oe_id' => '101-01',
                'name'  => 'Community Gardens',
                'parent_id' => @food.id,
                'slug' => 'community-gardens'
              },
              {
                'id'    => @dental.id,
                'depth' => 0,
                'oe_id' => '102',
                'name'  => 'Dental',
                'parent_id' => nil,
                'slug' => 'dental'
              },
              {
                'id'    => @dental_child.id,
                'depth' => 1,
                'oe_id' => '102-01',
                'name'  => 'Orthodontics',
                'parent_id' => @dental.id,
                'slug' => 'orthodontics'
              }
            ],
            'name' => @location.services.first.name,
            'updated_at' => service_formatted_time
          }],
          'organization' => {
            'id' => @location.organization.id,
            'name' => 'Parent Agency',
            'slug' => 'parent-agency',
            'url' => "#{path}/#{@location.organization.id}",
            'locations_url' => locations_url
          }
        }
        expect(json).to eq(represented)
      end
    end
  end
end
