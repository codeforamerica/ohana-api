require 'rails_helper'

describe PhoneImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_phone_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_phone.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_location_phone.csv').read }
  let(:valid_service_phone) { Rails.root.join('spec/support/fixtures/valid_service_phone.csv').read }
  let(:valid_org_phone) { Rails.root.join('spec/support/fixtures/valid_org_phone.csv').read }
  let(:valid_contact_phone) { Rails.root.join('spec/support/fixtures/valid_contact_phone.csv').read }
  let(:no_parent) { Rails.root.join('spec/support/fixtures/phone_with_no_parent.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { PhoneImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the phone headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the phone content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the phone headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the phone headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('number_type column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the phone content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Number type can't be blank for Phone"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ['Line 2: Phone must belong to either a Contact, Location, ' \
        'Organization or Service']

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a phone' do
      let(:content) { valid_content }

      it 'creates a phone' do
        expect { importer.import }.to change(Phone, :count).by(1)
      end

      describe 'the phone' do
        before { importer.import }

        subject { Phone.first }

        its(:department) { is_expected.to eq 'Food Pantry' }
        its(:extension) { is_expected.to eq '123' }
        its(:number) { is_expected.to eq '703-555-1212' }
        its(:number_type) { is_expected.to eq 'voice' }
        its(:vanity_number) { is_expected.to eq '703-555-FOOD' }
        its(:country_prefix) { is_expected.to eq '1' }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when the phone belongs to a service' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      let(:content) { valid_service_phone }

      describe 'the phone' do
        before { importer.import }

        subject { Phone.first }

        its(:service_id) { is_expected.to eq 1 }
      end
    end

    context 'when the phone belongs to an organization' do
      let(:content) { valid_org_phone }

      describe 'the phone' do
        before { importer.import }

        subject { Phone.first }

        its(:organization_id) { is_expected.to eq 1 }
      end
    end

    context 'when the phone belongs to a contact' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location).contacts.create!(attributes_for(:contact))
      end

      let(:content) { valid_contact_phone }

      describe 'the phone' do
        before { importer.import }

        subject { Phone.first }

        its(:contact_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a phone is blank' do
      let(:content) { invalid_content }

      it 'does not create a phone' do
        expect { importer.import }.to change(Phone, :count).by(0)
      end
    end

    context 'when the phone already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location).phones.create!(attributes_for(:phone))
      end

      let(:content) { valid_content }

      it 'does not create a new phone' do
        expect { importer.import }.to_not change(Phone, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a phone' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location_phone.csv')
          PhoneImporter.check_and_import_file(path)
        end.to change(Phone, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a phone' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_phone.csv')
          PhoneImporter.check_and_import_file(path)
        end.not_to change(Phone, :count)
      end
    end

    context 'when file is missing but required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/data/phones.csv')
          PhoneImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when file is empty and required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/phones.csv')
          PhoneImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end
  end
end
