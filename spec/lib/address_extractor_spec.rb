require 'rails_helper'

describe AddressExtractor do
  describe '.extract_addresses' do
    context 'with valid data' do
      it 'extracts the addresses' do
        address_hash = {
          id: '1',
          location_id: '2',
          address_1: '123 Main Street',
          address_2: 'Suite 101',
          city: 'Fairfax',
          state_province: 'VA',
          postal_code: '22031',
          country: 'US'
        }
        addresses = [
          address_hash,
          address_hash.merge(id: '2', location_id: '3'),
          address_hash.merge(id: '4', location_id: '1')
        ]

        path = Rails.root.join('spec', 'support', 'fixtures', 'valid_address.csv')
        expect(AddressExtractor.extract_addresses(path)).to eq addresses
      end
    end

    context 'with invalid data' do
      it 'extracts the addresses as is' do
        address_hash = {
          id: '1',
          location_id: '1',
          address_1: '123 Main Street',
          address_2: 'Suite 101',
          state_province: 'VA',
          postal_code: '22031',
          country: 'US'
        }

        path = Rails.root.join('spec', 'support', 'fixtures', 'invalid_address.csv')
        expect(AddressExtractor.extract_addresses(path)).
          to eq [address_hash,
                 address_hash.merge(id: '2', location_id: '2', city: 'Fairfax')]
      end
    end
  end
end
