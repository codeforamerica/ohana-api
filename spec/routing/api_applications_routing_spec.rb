require 'rails_helper'

describe ApiApplicationsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/api_applications')).to route_to('api_applications#index')
    end

    it 'routes to #new' do
      expect(get('/api_applications/new')).to route_to('api_applications#new')
    end

    it 'routes to #show' do
      expect(get('/api_applications/1'))
        .to route_to('api_applications#edit', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/api_applications/1/edit'))
        .to route_to('api_applications#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/api_applications')).to route_to('api_applications#create')
    end

    it 'routes to #update' do
      expect(put('/api_applications/1'))
        .to route_to('api_applications#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/api_applications/1'))
        .to route_to('api_applications#destroy', id: '1')
    end
  end
end
