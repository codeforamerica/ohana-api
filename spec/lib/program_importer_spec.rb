require 'rails_helper'

describe ProgramImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_program_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_program.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_program.csv').read }
  let(:no_parent) { Rails.root.join('spec/support/fixtures/program_with_no_parent.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:organization)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { ProgramImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the program headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the program content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the program headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the program headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('alternate_name column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the program content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Name can't be blank for Program"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ["Line 2: Organization can't be blank for Program"]

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a program' do
      let(:content) { valid_content }

      it 'creates a program' do
        expect { importer.import }.to change(Program, :count).by(1)
      end

      describe 'the program' do
        before { importer.import }

        subject { Program.first }

        its(:name) { is_expected.to eq 'Defeat Hunger' }
        its(:alternate_name) { is_expected.to be_nil }
        its(:organization_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a program is blank' do
      let(:content) { invalid_content }

      it 'does not create a program' do
        expect { importer.import }.to change(Program, :count).by(0)
      end
    end

    context 'when the program already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:program)
      end

      let(:content) { valid_content }

      it 'does not create a new program' do
        expect { importer.import }.to_not change(Program, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    context 'with valid data' do
      it 'creates a program' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_program.csv')
          ProgramImporter.check_and_import_file(path)
        end.to change(Program, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a program' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_program.csv')
          ProgramImporter.check_and_import_file(path)
        end.not_to change(Program, :count)
      end
    end

    context 'when file is missing but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/data/programs.csv')
          ProgramImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end

    context 'when file is empty but not required' do
      it 'does not raise an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/programs.csv')
          ProgramImporter.check_and_import_file(path)
        end.not_to raise_error
      end
    end
  end
end
