require 'active_record'
require 'support/api_constraints_spec_helper'
require_relative '../../lib/api_constraints'

describe ApiConstraints do
  let(:request) { double :request }

  describe '#matches?' do
    it 'matches requests including the versioned vendor mime type' do
      constraint = described_class.new(version: 1)
      headers = { 'Accept' => header_for_version(1) }
      allow(request).to receive(:headers) { headers }

      expect(constraint.matches?(request)).to eq(true)
    end

    it 'matches requests for other specified versions' do
      constraint = described_class.new(version: 2)
      headers = { 'Accept' => header_for_version(2) }
      allow(request).to receive(:headers) { headers }

      expect(constraint.matches?(request)).to eq(true)
    end

    it 'matches requests in the wrong format' do
      constraint = described_class.new(version: 1)
      headers = { 'Accept' => 'wrong format' }
      allow(request).to receive(:headers) { headers }

      expect(constraint.matches?(request)).to eq(true)
    end
  end
end
