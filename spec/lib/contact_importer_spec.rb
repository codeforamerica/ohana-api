require 'rails_helper'

describe ContactImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_contact_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_contact.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_location_contact.csv').read }
  let(:valid_service_contact) { Rails.root.join('spec/support/fixtures/valid_service_contact.csv').read }
  let(:valid_org_contact) { Rails.root.join('spec/support/fixtures/valid_org_contact.csv').read }
  let(:no_parent) { Rails.root.join('spec/support/fixtures/contact_with_no_parent.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { ContactImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the contact headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the contact content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the contact headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the contact headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('name column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the contact content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Name can't be blank for Contact"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ['Line 2: Contact must belong to either a Location, ' \
        'Organization or Service']

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a contact' do
      let(:content) { valid_content }

      it 'creates a contact' do
        expect { importer.import }.to change(Contact, :count).by(1)
      end

      describe 'the contact' do
        before { importer.import }

        subject { Contact.first }

        its(:department) { is_expected.to eq 'Food Pantry' }
        its(:email) { is_expected.to eq 'john@example.org' }
        its(:name) { is_expected.to eq 'John Smith' }
        its(:title) { is_expected.to eq 'Food Pantry Manager' }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when the contact belongs to a service' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      let(:content) { valid_service_contact }

      describe 'the contact' do
        before { importer.import }

        subject { Contact.first }

        its(:service_id) { is_expected.to eq 1 }
      end
    end

    context 'when the contact belongs to an organization' do
      let(:content) { valid_org_contact }

      describe 'the contact' do
        before { importer.import }

        subject { Contact.first }

        its(:organization_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a contact is blank' do
      let(:content) { invalid_content }

      it 'does not create a contact' do
        expect { importer.import }.to change(Contact, :count).by(0)
      end
    end

    context 'when the contact already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location).contacts.create!(attributes_for(:contact))
      end

      let(:content) { valid_content }

      it 'does not create a new contact' do
        expect { importer.import }.to_not change(Contact, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a contact' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location_contact.csv')
          ContactImporter.check_and_import_file(path)
        end.to change(Contact, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a contact' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_contact.csv')
          ContactImporter.check_and_import_file(path)
        end.not_to change(Contact, :count)
      end
    end

    context 'when file is missing but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/data/contacts.csv')
          ContactImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end

    context 'when file is empty but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/contacts.csv')
          ContactImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end
  end
end
