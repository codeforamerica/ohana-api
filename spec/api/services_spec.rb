require 'spec_helper'

describe Ohana::API do

  describe 'PUT Requests for Services' do
    include DefaultUserAgent
    include Features::SessionHelpers

    describe 'PUT /api/services/:id/' do
      before(:each) do
        create_service
        @token = ENV['ADMIN_APP_TOKEN']
      end

      it "doesn't allow setting non-whitelisted attributes" do
        put(
          "api/services/#{@service.id}/",
          { foo: 'bar', keywords: ['test'] },
          'HTTP_X_API_TOKEN' => @token
        )
        @service.reload
        expect(response).to be_success
        json.should_not include 'foo'
        json['keywords'].should == ['test']
      end

      it 'updates search index when service changes' do
        put(
          "api/services/#{@service.id}/",
          { description: 'fresh tunes for the soul' },
          'HTTP_X_API_TOKEN' => @token
        )
        get '/api/search?keyword=yoga'
        expect(headers['X-Total-Count']).to eq '0'
      end

      it 'validates service areas' do
        put(
          "api/services/#{@service.id}/",
          { service_areas: %w(belmont Atherton) },
          'HTTP_X_API_TOKEN' => @token
        )
        @service.reload
        expect(response.status).to eq(400)
        json['message'].should include 'At least one service area'
      end

      it 'ensures keywords is an array' do
        put(
          "api/services/#{@service.id}/",
          { keywords: 'health' },
          'HTTP_X_API_TOKEN' => @token
        )
        @service.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Attribute was supposed to be a Array, but was a String.'
      end

      it 'ensures service_areas is an array' do
        put(
          "api/services/#{@service.id}/",
          { service_areas: 'health' },
          'HTTP_X_API_TOKEN' => @token
        )
        @service.reload
        expect(response.status).to eq(400)
        expect(json['message']).
          to include 'Attribute was supposed to be a Array, but was a String.'
      end
    end

    describe 'Update a service without a valid token' do
      it "doesn't allow updating a service witout a valid token" do
        create_service
        put(
          "api/services/#{@service.id}",
          { name: 'new name' },
          'HTTP_X_API_TOKEN' => 'invalid_token'
        )
        @service.reload
        expect(response.status).to eq(401)
      end
    end

    describe 'PUT /api/services/:services_id/categories' do
      before(:each) do
        create_service
        @token = ENV['ADMIN_APP_TOKEN']
        @food = Category.create!(name: 'Food', oe_id: '101')
      end

      context 'when the passed in slug exists' do
        it "updates a service's categories" do
          put(
            "api/services/#{@service.id}/categories",
            { category_slugs: ['food'] },
            'HTTP_X_API_TOKEN' => @token
          )
          @service.reload
          expect(response).to be_success
          json['categories'].first['name'].should == 'Food'
        end
      end

      context "when the passed in slug doesn't exist" do
        it 'raises a 404 error' do
          put(
            "api/services/#{@service.id}/categories",
            { category_slugs: ['health'] },
            'HTTP_X_API_TOKEN' => @token
          )
          @service.reload
          expect(response.status).to eq(404)
          json['message'].should include 'could not be found'
        end
      end
    end
  end
end
