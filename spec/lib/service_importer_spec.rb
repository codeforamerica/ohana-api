require 'rails_helper'

describe ServiceImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_service_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_service.csv').read }
  let(:invalid_location) { Rails.root.join('spec/support/fixtures/invalid_service_location.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_service.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    @org = create(:location).organization
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { ServiceImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the service headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the service content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the service headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the service headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('name column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the service content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Name can't be blank for Service"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the location_id does not exist' do
      let(:content) { invalid_location }

      errors = ["Line 2: Location can't be blank for Service"]

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a service' do
      let(:content) { valid_content }

      it 'creates a service' do
        expect { importer.import }.to change(Service, :count).by(1)
      end

      describe 'the service' do
        before { importer.import }

        subject { Service.first }

        its(:accepted_payments) { is_expected.to eq ['Cash', 'Check', 'Credit Card'] }
        its(:alternate_name) { is_expected.to be_nil }
        its(:description) { is_expected.to eq 'Provides free hot meals to the homeless.' }
        its(:eligibility) { is_expected.to eq 'Homeless and low-income residents.' }
        its(:email) { is_expected.to eq 'info@service.org' }
        its(:funding_sources) { is_expected.to eq ['DC Government', 'Donations'] }
        its(:how_to_apply) { is_expected.to eq 'Call or apply in person' }
        its(:keywords) { is_expected.to eq ['hot meels', 'hungry'] }
        its(:languages) { is_expected.to eq %w(English Spanish Tagalog) }
        its(:name) { is_expected.to eq 'Harvest Food Bank of Palo Alto' }
        its(:service_areas) { is_expected.to eq %w(Atherton Belmont) }
        its(:status) { is_expected.to eq 'active' }
        its(:wait_time) { is_expected.to eq 'No wait.' }
        its(:website) { is_expected.to eq 'http://example.org/service' }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when the service belongs to a program' do
      before do
        @org.programs.create!(attributes_for(:program))
      end

      let(:content) { valid_content }

      describe 'the service' do
        before { importer.import }

        subject { Service.first }

        its(:program_id) { is_expected.to eq 1 }
      end
    end

    context 'when the service belongs to a category' do
      before do
        create(:category)
        create(:health)
      end

      let(:content) { valid_content }

      describe 'the service' do
        before { importer.import }

        subject { Service.first }

        its('categories.count') { is_expected.to eq 2 }
      end
    end

    context 'when one of the fields required for a service is blank' do
      let(:content) { invalid_content }

      it 'does not create a service' do
        expect { importer.import }.to change(Service, :count).by(0)
      end
    end

    context 'when the service already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      let(:content) { valid_content }

      it 'does not create a new service' do
        expect { importer.import }.to_not change(Service, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a service' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_service.csv')
          ServiceImporter.check_and_import_file(path)
        end.to change(Service, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a service' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_service.csv')
          ServiceImporter.check_and_import_file(path)
        end.not_to change(Service, :count)
      end
    end

    context 'when file is missing but required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/data/services.csv')
          ServiceImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when file is empty and required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/services.csv')
          ServiceImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end
  end
end
