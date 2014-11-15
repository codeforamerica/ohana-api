require 'rails_helper'

describe OrganizationPresenter do
  let(:properties) do
    {
      id: 1,
      name: 'Parent Agency',
      description: 'Example description'
    }
  end

  subject(:presenter) { OrganizationPresenter.new(properties) }

  describe '#to_org' do
    context 'when the org is valid' do
      it 'initializes a new org' do
        org = presenter.to_org
        expect { org.save! }.to change(Organization, :count).by(1)
      end
    end

    context 'when the org is not valid' do
      let(:properties) do
        {
          id: '1',
          description: 'Example description'
        }
      end

      it 'does not create a new org' do
        org = presenter.to_org
        expect { org.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when the org already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:organization)
      end

      it 'does not create a new org' do
        org = presenter.to_org
        expect { org.save! }.not_to change(Organization, :count)
      end
    end

    context 'when the org has comma-separated field values' do
      let(:properties) do
        {
          id: '1',
          name: 'Example org',
          description: 'Example description',
          accreditations: 'one ,two',
          funding_sources: 'donations, grants ',
          licenses: ' license1, license2 '
        }
      end

      it 'transforms accreditations' do
        org = presenter.to_org
        expect(org.attributes['accreditations']).to eq %w(one two)
      end

      it 'transforms funding_sources' do
        org = presenter.to_org
        expect(org.attributes['funding_sources']).to eq %w(donations grants)
      end

      it 'transforms licenses' do
        org = presenter.to_org
        expect(org.attributes['licenses']).to eq %w(license1 license2)
      end
    end

    context 'when the org has nil field values' do
      let(:properties) do
        {
          id: '1',
          name: 'Example org',
          description: 'Example description',
          accreditations: nil,
          funding_sources: nil,
          licenses: nil
        }
      end

      it 'set accreditations to empty array' do
        org = presenter.to_org
        expect(org.attributes['accreditations']).to eq []
      end

      it 'set funding_sources to empty array' do
        org = presenter.to_org
        expect(org.attributes['funding_sources']).to eq []
      end

      it 'set licenses to empty array' do
        org = presenter.to_org
        expect(org.attributes['licenses']).to eq []
      end
    end
  end
end
