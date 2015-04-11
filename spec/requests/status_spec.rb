require 'rails_helper'

describe 'GET /api/.well-known/status' do
  context 'when everything is ok' do
    before(:each) do
      create(:loc_with_nil_fields)
      get '/api/.well-known/status'
    end

    it 'returns a 200 HTTP status' do
      expect(response).to have_http_status(200)
    end

    it 'lists all dependencies' do
      expect(json['dependencies']).to eq(%w(Mandrill Postgres))
    end

    it "returns 'ok' status" do
      expect(json['status']).to eq('ok')
    end

    it "returns 'updated' attribute set to current time" do
      expect(json['updated']).to eq(Time.zone.now.to_i)
    end
  end

  context 'when everything is not ok' do
    before(:each) do
      get '/api/.well-known/status'
    end

    it "returns 'NOT OK' status" do
      expect(json['status']).to eq('NOT OK')
    end

    it 'returns a 200 HTTP status' do
      expect(response).to have_http_status(200)
    end

    it 'lists all dependencies' do
      expect(json['dependencies']).to eq(%w(Mandrill Postgres))
    end

    it "returns 'updated' attribute set to current time" do
      expect(json['updated']).to eq(Time.zone.now.to_i)
    end
  end
end
