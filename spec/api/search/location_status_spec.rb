require 'rails_helper'

describe "GET 'search'" do
  context 'with status parameter' do
    before(:each) do
      create(:nearby_loc)
      @location = create(:location)
      @attrs =  attributes_for(:service)
    end

    it 'only returns active locations when status=active' do
      @location.services.create!(@attrs.merge(status: 'inactive'))
      get 'api/search?status=active'
      expect(json.length).to eq(1)
      expect(json.first['name']).to eq 'Library'
    end

    it 'only returns inactive locations when status != active' do
      @location.services.create!(@attrs.merge(status: 'inactive'))
      get 'api/search?status=inactive'
      expect(json.length).to eq(1)
      expect(json.first['name']).to eq 'VRS Services'
    end
  end
end
