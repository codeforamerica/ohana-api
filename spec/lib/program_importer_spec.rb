require 'rails_helper'

describe ProgramImporter do
  let(:invalid_content) { Rails.root.join('spec', 'support', 'fixtures', 'invalid_program.csv') }
  let(:valid_content) { Rails.root.join('spec', 'support', 'fixtures', 'valid_program.csv') }
  let(:no_parent) { Rails.root.join('spec', 'support', 'fixtures', 'program_with_no_parent.csv') }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:organization)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { ProgramImporter.new(content) }

  describe '#valid?' do
    context 'when the program content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
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

        its(:id) { is_expected.to eq 2 }
        its(:name) { is_expected.to eq 'Defeat Hunger' }
        its(:alternate_name) { is_expected.to be_nil }
        its(:organization_id) { is_expected.to eq 1 }
      end
    end

    context 'when one of the fields required for a program is blank' do
      let(:content) { invalid_content }

      it 'saves the valid entries and skips invalid ones' do
        expect { importer.import }.to change(Program, :count).by(1)
      end
    end

    context 'when the program already exists' do
      before do
        importer.import
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
    it 'calls FileChecker' do
      path = Rails.root.join('spec', 'support', 'fixtures', 'valid_program.csv')

      file = double('FileChecker')
      allow(file).to receive(:validate).and_return true

      expect(Kernel).to receive(:puts).
        with("\n===> Importing valid_program.csv")

      expect(FileChecker).to receive(:new).
        with(path, ProgramImporter.required_headers).and_return(file)

      ProgramImporter.check_and_import_file(path)
    end

    context 'with invalid data' do
      it 'outputs error message' do
        expect(Kernel).to receive(:puts).
          with("\n===> Importing invalid_program.csv")

        expect(Kernel).to receive(:puts).
          with("Line 2: Name can't be blank for Program")

        path = Rails.root.join('spec', 'support', 'fixtures', 'invalid_program.csv')
        ProgramImporter.check_and_import_file(path)
      end
    end
  end

  describe '.required_headers' do
    it 'matches required headers in Wiki' do
      expect(ProgramImporter.required_headers).
        to eq %w[id organization_id name alternate_name]
    end
  end
end
