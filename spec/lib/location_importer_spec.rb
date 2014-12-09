require 'rails_helper'

describe LocationImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_location_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_location.csv').read }
  let(:invalid_org) { Rails.root.join('spec/support/fixtures/invalid_location_org.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_location.csv').read }

  let(:valid_address) do
    path = Rails.root.join('spec/support/fixtures/valid_address.csv')
    AddressExtractor.extract_addresses(path)
  end
  let(:invalid_address) do
    path = Rails.root.join('spec/support/fixtures/invalid_address.csv')
    AddressExtractor.extract_addresses(path)
  end
  let(:missing_address) do
    path = Rails.root.join('spec/support/fixtures/missing_address.csv')
    AddressExtractor.extract_addresses(path)
  end

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:organization)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { LocationImporter.new(content, address) }

  describe '#valid_headers?' do
    context 'when the location headers are invalid' do
      let(:content) { invalid_header_content }
      let(:address) { valid_address }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }
      let(:address) { valid_address }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the location content is invalid' do
      let(:content) { invalid_content }
      let(:address) { valid_address }

      it { is_expected.not_to be_valid }
    end

    context 'when only the address content is invalid' do
      let(:content) { valid_content }
      let(:address) { invalid_address }

      it { is_expected.not_to be_valid }
    end

    context 'when the location headers are invalid' do
      let(:content) { invalid_header_content }
      let(:address) { valid_address }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }
      let(:address) { valid_address }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the location headers are invalid' do
      let(:content) { invalid_header_content }
      let(:address) { valid_address }

      its(:errors) { is_expected.to include('name column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }
      let(:address) { valid_address }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the location content is not valid' do
      let(:content) { invalid_content }
      let(:address) { valid_address }

      errors = ["Line 2: Name can't be blank for Location"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the address content is not valid' do
      let(:content) { valid_content }
      let(:address) { invalid_address }

      errors = ["Line 2: Address city can't be blank for Address"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when there is no matching address' do
      let(:content) { valid_content }
      let(:address) { missing_address }

      errors = ["Line 2: Address Unless it's virtual, a location must have an address."]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the organization_id does not exist' do
      let(:content) { invalid_org }
      let(:address) { valid_address }

      errors = ["Line 2: Organization can't be blank for Location"]

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a location' do
      let(:content) { valid_content }
      let(:address) { valid_address }

      it 'creates a location' do
        expect { importer.import }.to change(Location, :count).by(1)
      end

      describe 'the location' do
        before { importer.import }

        subject { Location.first }

        its(:name) { is_expected.to eq 'Harvest Food Bank' }
        its(:latitude) { is_expected.to eq(37.7726402) }
        its(:longitude) { is_expected.to eq(-122.4099154) }
        its(:organization_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a location is blank' do
      let(:content) { invalid_content }
      let(:address) { valid_address }

      it 'does not create a location' do
        expect { importer.import }.to change(Location, :count).by(0)
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a location' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location.csv')
          address_path = Rails.root.join('spec/support/fixtures/valid_address.csv')
          LocationImporter.check_and_import_file(path, address_path)
        end.to change(Location, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a location' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_location.csv')
          address_path = Rails.root.join('spec/support/fixtures/invalid_address.csv')
          LocationImporter.check_and_import_file(path, address_path)
        end.not_to change(Location, :count)
      end
    end

    context 'when only address is invalid' do
      it 'does not create a location' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location.csv')
          address_path = Rails.root.join('spec/support/fixtures/invalid_address.csv')
          LocationImporter.check_and_import_file(path, address_path)
        end.not_to change(Location, :count)
      end
    end

    context 'when address is missing' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/fixtures/valid_location.csv')
        address_path = Rails.root.join('spec/support/data/addresses.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when address is empty' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/fixtures/valid_location.csv')
        address_path = Rails.root.join('spec/support/fixtures/addresses.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when location is missing' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/data/locations.csv')
        address_path = Rails.root.join('spec/support/data/valid_address.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when location is empty' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/fixtures/locations.csv')
        address_path = Rails.root.join('spec/support/fixtures/valid_address.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when both are missing' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/data/locations.csv')
        address_path = Rails.root.join('spec/support/data/addresses.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when both are empty' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/fixtures/locations.csv')
        address_path = Rails.root.join('spec/support/fixtures/addresses.csv')

        expect do
          LocationImporter.check_and_import_file(path, address_path)
        end.to raise_error(/missing or empty/)
      end
    end
  end
end
