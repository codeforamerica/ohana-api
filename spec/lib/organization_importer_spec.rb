require 'rails_helper'

describe OrganizationImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_org_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_org.csv').read }
  let(:invalid_date) { Rails.root.join('spec/support/fixtures/org_with_invalid_date.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_org.csv').read }
  let(:spelled_out_date) { Rails.root.join('spec/support/fixtures/org_with_spelled_out_date.csv').read }
  let(:org_with_2_digit_year) { Rails.root.join('spec/support/fixtures/org_with_2_digit_year.csv').read }

  subject(:importer) { OrganizationImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the org headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the org content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the org headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the org headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('name column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

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

        subject { Organization.first }

        its(:accreditations) { is_expected.to eq ['BBB', 'State Board of Education'] }
        its(:alternate_name) { is_expected.to eq 'HFB' }
        its(:date_incorporated) { is_expected.to eq Date.parse('January 2, 1970') }
        its(:description) { is_expected.to eq 'Harvest Food Bank provides fresh produce, dairy, and canned goods to food pantries throughout the city.' }
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

      it 'does not create a org' do
        expect { importer.import }.to change(Organization, :count).by(0)
      end
    end

    context 'when the org already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:organization)
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
    context 'with valid data' do
      it 'creates an org' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_org.csv')
          OrganizationImporter.check_and_import_file(path)
        end.to change(Organization, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create an org' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_org.csv')
          OrganizationImporter.check_and_import_file(path)
        end.not_to change(Organization, :count)
      end
    end

    context 'when file is missing but required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/data/organizations.csv')
          OrganizationImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when file is empty and required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/organizations.csv')
          OrganizationImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end
  end
end
