require 'rails_helper'
require 'csv'

describe OrganizationParser do
  describe  '#parse' do
    context 'with new organization' do
      let(:data) do
        Rails.
          root.
          join('spec', 'support', 'fixtures', 'data', 'valid_organization.csv')
      end

      it 'creates a new organization and its relationships' do
        CSV.foreach(data, headers: true) do |row|
          result = described_class.execute(row)
          expect(result).to be_kind_of(Organization)
          expect(result.contacts).to_not be_empty
          expect(result.contacts.count).to be_equal(1)
          expect(result.phones).to_not be_empty
          expect(result.phones.count).to be_equal(1)
        end
      end

      it 'raises an error with invalid information' do
      end
    end

    context 'when the organization is already exist' do
      it 'updates the organization and creates its relationships' do
      end
    end
  end
end
