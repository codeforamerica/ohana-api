require 'spec_helper'

describe StatusController do

  describe 'GET /.well-known/status' do

    it 'returns success' do
      create(:loc_with_nil_fields)
      get 'check_status'
      expect(response).to be_success
    end

    context "when DB can't find any Categories" do
      it 'returns error' do
        create(:loc_with_nil_fields)
        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('DB did not return location or category')
      end
    end

    context 'when DB and search are up and running' do
      it 'returns ok status' do
        create(:loc_with_nil_fields)
        category = create(:category)
        FactoryGirl.create(
          :service_with_nil_fields,
          category_ids: ["#{category.id}"]
        )
        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
      end
    end

    context 'when search returns no results' do
      it 'returns search failure status' do
        create(:location)
        create(:category)
        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('Search returned no results')
      end
    end
  end
end
