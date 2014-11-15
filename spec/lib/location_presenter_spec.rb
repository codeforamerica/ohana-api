require 'rails_helper'

describe LocationPresenter do
  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:organization)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  let(:properties) do
    {
      organization_id: '1',
      id: '1',
      name: 'Example Location',
      description: 'Example description'
    }
  end

  let(:addresses) do
    path = Rails.root.join('spec/support/fixtures/valid_address.csv')
    AddressExtractor.extract_addresses(path)
  end

  let(:missing_addresses) do
    path = Rails.root.join('spec/support/fixtures/missing_address.csv')
    AddressExtractor.extract_addresses(path)
  end

  subject(:presenter) { LocationPresenter.new(properties, addresses) }

  describe '#to_location' do
    context 'when the location is valid' do
      it 'initializes a new location' do
        location = presenter.to_location
        expect { location.save! }.to change(Location, :count).by(1)
      end
    end

    context 'when the location is not valid' do
      let(:addresses) { missing_addresses }

      it 'does not create a new location' do
        location = presenter.to_location
        expect { location.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when the location already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location)
      end

      it 'does not create a new location' do
        location = presenter.to_location
        expect { location.save! }.not_to change(Location, :count)
      end
    end

    context 'when the location has comma-separated field values' do
      let(:properties) do
        {
          organization_id: '1',
          id: '1',
          name: 'Example Location',
          description: 'Example description',
          accessibility: 'ramp ,wheelchair',
          admin_emails: 'foo@bar.com, bar@foo.com ',
          languages: ' English, French ',
          virtual: nil
        }
      end

      it 'transforms accessibility' do
        location = presenter.to_location
        expect(location.attributes['accessibility']).to eq %w(ramp wheelchair)
      end

      it 'transforms admin_emails' do
        location = presenter.to_location
        expect(location.attributes['admin_emails']).to eq %w(foo@bar.com bar@foo.com)
      end

      it 'transforms languages' do
        location = presenter.to_location
        expect(location.attributes['languages']).to eq %w(English French)
      end
    end

    context 'when the location has nil field values' do
      let(:properties) do
        {
          organization_id: '1',
          id: '1',
          name: 'Example Location',
          description: 'Example description',
          accessibility: nil,
          admin_emails: nil,
          languages: nil,
          virtual: nil
        }
      end

      it 'set accessibility to empty array' do
        location = presenter.to_location
        expect(location.attributes['accessibility']).to eq []
      end

      it 'set admin_emails to empty array' do
        location = presenter.to_location
        expect(location.attributes['admin_emails']).to eq []
      end

      it 'set languages to empty array' do
        location = presenter.to_location
        expect(location.attributes['languages']).to eq []
      end

      it 'sets virtual to false' do
        location = presenter.to_location
        expect(location.attributes['virtual']).to eq false
      end
    end

    context 'when the location is virtual' do
      let(:properties) do
        {
          organization_id: '1',
          id: '1',
          name: 'Example Location',
          description: 'Example description',
          virtual: true
        }
      end

      it 'does not set address attributes' do
        location = presenter.to_location
        expect(location.address).to be_nil
      end
    end

    context 'when there is no matching address' do
      let(:addresses) { missing_addresses }

      let(:properties) do
        {
          organization_id: '1',
          id: '1',
          name: 'Example Location',
          description: 'Example description'
        }
      end

      it 'does not set address attributes' do
        location = presenter.to_location
        expect(location.address).to be_nil
      end
    end

    context 'when there is a matching address' do
      let(:properties) do
        {
          organization_id: '1',
          id: '1',
          name: 'Example Location',
          description: 'Example description'
        }
      end

      it 'sets address attributes' do
        location = presenter.to_location
        expect(location.address).to_not be_nil
      end
    end
  end
end
