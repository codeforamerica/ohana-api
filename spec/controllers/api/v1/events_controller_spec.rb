require 'rails_helper'

describe Api::V1::EventsController do
  before do
    @user = create :unconfirmed_user
    @auth_header = api_login(@user)
    @org = create :organization
  end

  describe 'GET #index' do
    it 'responds with the list of all events' do
      create :event, organization: @org
      get :index
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['title']).to eq('Test Event')
      expect(parsed_response.first['city']).to eq('Los Angeles')
    end

    it 'can return only upcoming events' do
      assert_upcoming_past_events starting_after: DateTime.now
    end

    it 'can return only past events' do
      assert_upcoming_past_events ending_before: DateTime.now
    end

  #   it 'responds with events happening on January' do
  #     create(:event)
  #     Event.create!(
  #       title: 'Second Event',
  #       starting_at: '2019-01-06 22:30:00',
  #       ending_at: '2019-01-06 23:30:00',
  #       posted_at: '2019-01-06 18:30:00',
  #       city: 'Los Angeles',
  #       is_featured: false,
  #       street_1: 'Test street',
  #       organization_id: 1,
  #       user_id: @user.id
  #     )
  #     get :index, month: 1
  #     expect(Event.count).to eq(2)
  #     parsed_response = JSON.parse(response.body)
  #     expect(parsed_response.first['title']).to eq('Test Event')
  #     expect(parsed_response.first['city']).to eq('Los Angeles')
  #     expect(parsed_response.last['title']).to eq('Second Event')
  #   end
  end

  describe 'GET #show' do
    it 'responds with the info for an specific event' do
      event = create :event, organization: @org
      get :show, id: event.id
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Test Event')
      expect(parsed_response['city']).to eq('Los Angeles')
    end
  end

  # describe 'POST #create' do
  #   it 'creates a new event into database' do
  #     post :create, event: {
  #       title: 'My Event',
  #       starting_at: '2019-01-06 22:30:00',
  #       ending_at: '2019-01-06 23:30:00',
  #       city: 'Los Angeles',
  #       is_featured: false,
  #       street_1: 'Test street',
  #       organization_id: 1
  #     }, headers: @auth_header, format: :json
  #     parsed_response = JSON.parse(response.body)
  #     expect(parsed_response['title']).to eq('My Event')
  #     expect(parsed_response['city']).to eq('Los Angeles')
  #   end
  # end

  # describe 'PUT #update' do
  #   it 'updates an existing event' do
  #     event = create :event, organization: @org
  #     put :update, event: {
  #       title: 'Updated Event'
  #     }, id: event.id, headers: @auth_header, format: :json
  #     parsed_response = JSON.parse(response.body)
  #     expect(parsed_response['title']).to eq('Updated Event')
  #   end
  # end

  # describe 'DELETE #destroy' do
  #   it 'deletes an existing event' do
  #     event = create :event, organization: @org
  #     delete :destroy, id: event.id, headers: @auth_header, format: :json
  #     expect(Event.count).to eq(0)
  #   end
  # end
end

def assert_upcoming_past_events(params)
  create :event, starting_at: DateTime.yesterday, organization: @org
  create :event, starting_at: DateTime.tomorrow, organization: @org
  get :index, params
  parsed_response = JSON.parse(response.body)
  expect(parsed_response.count).to eq(1)
end
