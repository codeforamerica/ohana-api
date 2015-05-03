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

    it "returns 'updated' attribute set to current time as integer" do
      expect(json['updated'].is_a?(Integer)).to eq true
      expect(json['updated'].to_s.length).to eq 10
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

    it "returns 'updated' attribute set to current time as integer" do
      expect(json['updated'].is_a?(Integer)).to eq true
      expect(json['updated'].to_s.length).to eq 10
    end
  end
end
