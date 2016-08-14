require 'rails_helper'

describe MailAddressImporter do
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_mail_address.csv') }
  let(:invalid_location) do
    Rails.root.join('spec/support/fixtures/invalid_mail_address_location.csv')
  end
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_mail_address.csv') }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { MailAddressImporter.new(content) }

  describe '#valid?' do
    context 'when the mail_address content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the mail_address content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Address 1 can't be blank for Mail Address"]

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

        its(:id) { is_expected.to eq 2 }
        its(:attention) { is_expected.to eq 'John Smith' }
        its(:address_1) { is_expected.to eq '123 Main Street' }
        its(:address_2) { is_expected.to eq 'Suite 101' }
        its(:city) { is_expected.to eq 'Fairfax' }
        its(:state_province) { is_expected.to eq 'VA' }
        its(:postal_code) { is_expected.to eq '22031' }
        its(:country) { is_expected.to eq 'US' }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a mail_address is blank' do
      let(:content) { invalid_content }

      it 'saves the valid entries and skips invalid ones' do
        expect { importer.import }.to change(MailAddress, :count).by(1)
      end
    end

    context 'when the mail_address already exists' do
      before do
        importer.import
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
    it 'calls FileChecker' do
      path = Rails.root.join('spec/support/fixtures/valid_mail_address.csv')

      file = double('FileChecker')
      allow(file).to receive(:validate).and_return true

      expect(Kernel).to receive(:puts).
        with("\n===> Importing valid_mail_address.csv")

      expect(FileChecker).to receive(:new).
        with(path, MailAddressImporter.required_headers).and_return(file)

      MailAddressImporter.check_and_import_file(path)
    end

    context 'with invalid data' do
      it 'outputs error message' do
        expect(Kernel).to receive(:puts).
          with("\n===> Importing invalid_mail_address.csv")

        expect(Kernel).to receive(:puts).
          with("Line 2: Address 1 can't be blank for Mail Address")

        path = Rails.root.join('spec/support/fixtures/invalid_mail_address.csv')
        MailAddressImporter.check_and_import_file(path)
      end
    end
  end

  describe '.required_headers' do
    it 'matches required headers in Wiki' do
      expect(MailAddressImporter.required_headers).
        to eq %w(id location_id attention address_1 address_2 city
                 state_province postal_code country)
    end
  end
end
