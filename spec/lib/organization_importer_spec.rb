require 'rails_helper'

describe OrganizationImporter do
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_org.csv') }
  let(:invalid_date) { Rails.root.join('spec/support/fixtures/org_with_invalid_date.csv') }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_org.csv') }
  let(:spelled_out_date) { Rails.root.join('spec/support/fixtures/org_with_spelled_out_date.csv') }
  let(:org_with_2_digit_year) { Rails.root.join('spec/support/fixtures/org_with_2_digit_year.csv') }

  subject(:importer) { OrganizationImporter.new(content) }

  describe '#valid?' do
    context 'when the org content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the org content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Name can't be blank for Organization"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the date is not valid' do
      let(:content) { invalid_date }

      errors = ['Line 2: Date incorporated 24/2/70 is not a valid date']

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a org' do
      let(:content) { valid_content }

      it 'creates an org' do
        expect { importer.import }.to change(Organization, :count).by(1)
      end

      describe 'the org' do
        before { importer.import }

        subject { Organization.find(2) }

        its(:id) { is_expected.to eq 2 }
        its(:accreditations) { is_expected.to eq ['BBB', 'State Board of Education'] }
        its(:alternate_name) { is_expected.to eq 'HFB' }
        its(:date_incorporated) { is_expected.to eq Date.parse('January 2, 1970') }
        its(:description) { is_expected.to match 'Harvest Food Bank' }
        its(:email) { is_expected.to eq 'info@example.org' }
        its(:funding_sources) { is_expected.to eq %w(Donations Grants) }
        its(:legal_status) { is_expected.to eq 'Nonprofit' }
        its(:licenses) { is_expected.to eq ['State Health Inspection License'] }
        its(:name) { is_expected.to eq 'Parent Agency' }
        its(:tax_id) { is_expected.to eq '12-456789' }
        its(:tax_status) { is_expected.to eq '501(c)3' }
        its(:website) { is_expected.to eq 'http://www.example.org' }
      end
    end

    context 'when the date is formatted as month, day, year' do
      let(:content) { spelled_out_date }

      describe 'the org' do
        before { importer.import }

        subject { Organization.first }

        its(:date_incorporated) { is_expected.to eq Date.parse('January 20, 1970') }
      end
    end

    context 'when the year only contains two digits' do
      let(:content) { org_with_2_digit_year }

      describe 'the org' do
        before { importer.import }

        subject { Organization.first }

        its(:date_incorporated) { is_expected.to eq Date.parse('January 24, 1970') }
      end
    end

    context 'when one of the fields required for a org is blank' do
      let(:content) { invalid_content }

      it 'saves the valid entries and skips invalid ones' do
        expect { importer.import }.to change(Organization, :count).by(1)
      end
    end

    context 'when the org already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        importer.import
      end

      let(:content) { valid_content }

      it 'does not create a new org' do
        expect { importer.import }.to_not change(Organization, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    it 'calls FileChecker' do
      path = Rails.root.join('spec/support/fixtures/valid_org.csv')

      file = double('FileChecker')
      allow(file).to receive(:validate).and_return true

      expect(Kernel).to receive(:puts).
        with("\n===> Importing valid_org.csv")

      expect(FileChecker).to receive(:new).
        with(path, OrganizationImporter.required_headers).and_return(file)

      OrganizationImporter.check_and_import_file(path)
    end

    context 'with invalid data' do
      it 'outputs error message' do
        expect(Kernel).to receive(:puts).
          with("\n===> Importing invalid_org.csv")

        expect(Kernel).to receive(:puts).
          with("Line 2: Name can't be blank for Organization")

        path = Rails.root.join('spec/support/fixtures/invalid_org.csv')
        OrganizationImporter.check_and_import_file(path)
      end
    end
  end

  describe '.required_headers' do
    it 'matches required headers in Wiki' do
      expect(OrganizationImporter.required_headers).
        to eq %w(id accreditations alternate_name date_incorporated description
                 email funding_sources legal_status licenses name tax_id
                 tax_status website)
    end
  end
end
