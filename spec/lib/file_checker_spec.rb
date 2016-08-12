require 'rails_helper'

describe FileChecker do
  let(:required_and_full) { Rails.root.join('spec/support/fixtures/locations.csv') }
  let(:required_but_empty) { Rails.root.join('spec/support/fixtures/services.csv') }
  let(:required_but_missing) { Rails.root.join('spec/support/data/services.csv') }
  let(:missing_not_required) { Rails.root.join('spec/support/fixtures/foo.csv') }
  let(:empty_not_required) { Rails.root.join('spec/support/fixtures/taxonomy.csv') }
  let(:full_not_required) { Rails.root.join('spec/support/fixtures/programs.csv') }
  let(:invalid_headers) { Rails.root.join('spec/support/fixtures/invalid_program_headers.csv') }
  let(:required_headers) { %w(id organization_id name alternate_name) }

  subject(:checker) { FileChecker.new(path, required_headers) }

  describe '#filename' do
    let(:path) { required_and_full }

    its(:filename) { is_expected.to eq 'locations.csv' }
  end

  describe '#missing?' do
    context 'when the file exists' do
      let(:path) { required_and_full }

      it { is_expected.to_not be_missing }
    end

    context 'when the file does not exist' do
      let(:path) { missing_not_required }

      it { is_expected.to be_missing }
    end
  end

  describe '#required_but_missing?' do
    context 'when the file is required and present' do
      let(:path) { required_and_full }

      it { is_expected.to_not be_required_but_missing }
    end

    context 'when the file is required and missing' do
      let(:path) { required_but_missing }

      it { is_expected.to be_required_but_missing }
    end

    context 'when the file is missing but not required' do
      let(:path) { missing_not_required }

      it { is_expected.to_not be_required_but_missing }
    end

    context 'when the file is present but not required' do
      let(:path) { empty_not_required }

      it { is_expected.to_not be_required_but_missing }
    end
  end

  describe '#required_but_empty?' do
    context 'when the file is required and has content' do
      let(:path) { required_and_full }

      it { is_expected.to_not be_required_but_empty }
    end

    context 'when the file is required and empty' do
      let(:path) { required_but_empty }

      it { is_expected.to be_required_but_empty }
    end

    context 'when the file is not required but empty' do
      let(:path) { empty_not_required }

      it { is_expected.to_not be_required_but_empty }
    end

    context 'when the file is not required and has content' do
      let(:path) { full_not_required }

      it { is_expected.to_not be_required_but_empty }
    end
  end

  describe '#missing_or_empty?' do
    context 'when the file is required but missing' do
      let(:path) { required_but_missing }

      it { is_expected.to be_missing_or_empty }
    end

    context 'when the file is not required but missing' do
      let(:path) { missing_not_required }

      it { is_expected.to_not be_missing_or_empty }
    end

    context 'when the file is not required but empty' do
      let(:path) { empty_not_required }

      it { is_expected.to_not be_missing_or_empty }
    end

    context 'when the file is required but empty' do
      let(:path) { required_but_empty }

      it { is_expected.to be_missing_or_empty }
    end
  end

  describe '#invalid_headers?' do
    context 'when the headers are invalid' do
      let(:path) { invalid_headers }

      it { is_expected.to be_invalid_headers }
    end

    context 'when the headers are valid' do
      let(:path) { full_not_required }

      it { is_expected.to_not be_invalid_headers }
    end
  end

  describe '#header_errors' do
    let(:path) { invalid_headers }

    its(:header_errors) do
      is_expected.
        to eq ['CSV header alternate_name is required, but is missing.']
    end
  end

  describe '#required_files' do
    let(:path) { '/organizations.csv' }

    its(:required_files) do
      is_expected.
        to eq %w(organizations.csv locations.csv addresses.csv services.csv
                 phones.csv)
    end
  end

  describe '#validate' do
    context 'when file is required but missing' do
      let(:path) { required_but_missing }

      it 'aborts and displays a message' do
        allow_any_instance_of(Kernel).to receive(:abort).
          with('Aborting because services.csv is required, but is missing or empty.')

        checker.validate
      end
    end

    context 'when file is missing but not required' do
      let(:path) { missing_not_required }

      it 'returns skip prompt' do
        expect(checker.validate).to eq 'skip import'
      end
    end

    context 'when file is empty but not required' do
      let(:path) { empty_not_required }

      it 'returns skip prompt' do
        expect(checker.validate).to eq 'skip import'
      end
    end

    context 'when file is required but empty' do
      let(:path) { required_but_empty }

      it 'aborts and displays a message' do
        allow_any_instance_of(Kernel).to receive(:abort).
          with('Aborting because services.csv is required, but is missing or empty.')

        checker.validate
      end
    end

    context 'when file has invalid headers' do
      let(:path) { invalid_headers }

      it 'displays missing header message, then aborts with message' do
        allow_any_instance_of(IO).to receive(:puts).
          with('CSV header alternate_name is required, but is missing.')

        allow_any_instance_of(Kernel).to receive(:abort).
          with(
            'invalid_program_headers.csv was not imported. Please fix the headers and try again.'
          )

        checker.validate
      end
    end
  end
end
