require 'rails_helper'

describe Api::V1::EventsController do
  describe 'GET #index' do
    it 'responds with the list of all events' do
      create(:event)
      get :index
      expect(Event.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['title']).to eq('Test Event')
      expect(parsed_response.first['city']).to eq('Los Angeles')
    end

    it 'responds with events happening on January' do
      create(:event)
      Event.create!(
        title: 'Second Event',
        starting_at: '2019-01-06 22:30:00',
        ending_at: '2019-01-06 23:30:00',
        posted_at: '2019-01-06 18:30:00',
        city: 'Los Angeles',
        is_featured: false,
        street_1: 'Test street',
        organization_id: 1,
        admin_id: 1
      )
      get :index, month: 1
      expect(Event.count).to eq(2)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['title']).to eq('Test Event')
      expect(parsed_response.first['city']).to eq('Los Angeles')
      expect(parsed_response.last['title']).to eq('Second Event')
    end
  end

  describe 'GET #show' do
    it 'responds with the info for an specific event' do
      event = create(:event)
      get :show, id: event.id
      expect(Event.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Test Event')
      expect(parsed_response['city']).to eq('Los Angeles')
    end
  end

  describe 'POST #create' do
    it 'creates a new event into database' do
      post :create, event: {
        title: 'My Event',
        starting_at: '2019-01-06 22:30:00',
        ending_at: '2019-01-06 23:30:00',
        posted_at: '2019-01-06 18:30:00',
        city: 'Los Angeles',
        is_featured: false,
        street_1: 'Test street',
        organization_id: 1,
        admin_id: 1
      }
      expect(Event.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('My Event')
      expect(parsed_response['city']).to eq('Los Angeles')
    end
  end

  describe 'PUT #update' do
    it 'updates an existing event' do
      event = create(:event)
      put :update, event: {
        title: 'Updated Event'
      }, id: event.id
      expect(Event.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Updated Event')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes an existing event' do
      event = create(:event)
      expect(Event.count).to eq(1)
      delete :destroy, id: event.id
      expect(Event.count).to eq(0)
    end
  end
end
