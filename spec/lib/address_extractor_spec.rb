require 'rails_helper'

describe AddressExtractor do
  describe '.extract_addresses' do
    context 'with valid data' do
      it 'extracts the addresses' do
        address_hash = {
          id: '1',
          location_id: '1',
          street_1: '123 Main Street',
          street_2: 'Suite 101',
          city: 'Fairfax',
          state: 'VA',
          postal_code: '22031',
          country_code: 'US'
        }

        path = Rails.root.join('spec/support/fixtures/valid_address.csv')
        expect(AddressExtractor.extract_addresses(path)).to eq [address_hash]
      end
    end

    context 'with invalid data' do
      it 'extracts the addresses as is' do
        address_hash = {
          id: '1',
          location_id: '1',
          street_1: '123 Main Street',
          street_2: 'Suite 101',
          city: nil,
          state: 'VA',
          postal_code: '22031',
          country_code: 'US'
        }

        path = Rails.root.join('spec/support/fixtures/invalid_address.csv')
        expect(AddressExtractor.extract_addresses(path)).to eq [address_hash]
      end
    end
  end
end
