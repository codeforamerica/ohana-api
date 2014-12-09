require 'rails_helper'

describe MailAddressImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_mail_address_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_mail_address.csv').read }
  let(:invalid_location) { Rails.root.join('spec/support/fixtures/invalid_mail_address_location.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_mail_address.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { MailAddressImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the mail_address headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the mail_address content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the mail_address headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the mail_address headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('street_1 column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the mail_address content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Street 1 can't be blank for Mail Address"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the location_id does not exist' do
      let(:content) { invalid_location }

      errors = ["Line 2: Location can't be blank for Mail Address"]

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a mail_address' do
      let(:content) { valid_content }

      it 'creates an mail_address' do
        expect { importer.import }.to change(MailAddress, :count).by(1)
      end

      describe 'the mail_address' do
        before { importer.import }

        subject { MailAddress.first }

        its(:attention) { is_expected.to eq 'John Smith' }
        its(:street_1) { is_expected.to eq '123 Main Street' }
        its(:street_2) { is_expected.to eq 'Suite 101' }
        its(:city) { is_expected.to eq 'Fairfax' }
        its(:state) { is_expected.to eq 'VA' }
        its(:postal_code) { is_expected.to eq '22031' }
        its(:country_code) { is_expected.to eq 'US' }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a mail_address is blank' do
      let(:content) { invalid_content }

      it 'does not create a mail_address' do
        expect { importer.import }.to change(MailAddress, :count).by(0)
      end
    end

    context 'when the mail_address already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:mail_address)
      end

      let(:content) { valid_content }

      it 'does not create a new mail_address' do
        expect { importer.import }.to_not change(MailAddress, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a mail_address' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_mail_address.csv')
          MailAddressImporter.check_and_import_file(path)
        end.to change(MailAddress, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a mail_address' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_mail_address.csv')
          MailAddressImporter.check_and_import_file(path)
        end.not_to change(MailAddress, :count)
      end
    end

    context 'when file is missing but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/data/mail_addresses.csv')
          MailAddressImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end

    context 'when file is empty but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/mail_addresses.csv')
          MailAddressImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end
  end
end
