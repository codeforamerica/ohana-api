require 'rails_helper'

describe RegularScheduleImporter do
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_regular_schedule.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_location_regular_schedule.csv').read }
  let(:valid_service_regular_schedule) { Rails.root.join('spec/support/fixtures/valid_service_regular_schedule.csv').read }
  let(:no_parent) { Rails.root.join('spec/support/fixtures/regular_schedule_with_no_parent.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { RegularScheduleImporter.new(content) }

  describe '#valid?' do
    context 'when the regular_schedule content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the regular_schedule content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Closes at can't be blank for Regular Schedule"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ['Line 2: Regular Schedule is missing a parent: Location or ' \
        'Service']

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a regular_schedule' do
      let(:content) { valid_content }

      it 'creates a regular_schedule' do
        expect { importer.import }.to change(RegularSchedule, :count).by(1)
      end

      describe 'the regular_schedule' do
        before { importer.import }

        subject { RegularSchedule.first }

        its(:weekday) { is_expected.to eq 1 }
        its(:opens_at) { is_expected.to eq Time.utc(2000, 1, 1, 9, 30, 0) }
        its(:closes_at) { is_expected.to eq Time.utc(2000, 1, 1, 17, 00, 0) }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when the regular_schedule belongs to a service' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      let(:content) { valid_service_regular_schedule }

      describe 'the regular_schedule' do
        before { importer.import }

        subject { RegularSchedule.first }

        its(:service_id) { is_expected.to eq 1 }
      end
    end

    context 'when required field for a regular_schedule is blank' do
      let(:content) { invalid_content }

      it 'does not create a regular_schedule' do
        expect { importer.import }.to change(RegularSchedule, :count).by(0)
      end
    end

    context 'when the regular_schedule already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location).regular_schedules.
          create!(attributes_for(:regular_schedule))
      end

      let(:content) { valid_content }

      it 'does not create a new regular_schedule' do
        expect { importer.import }.to_not change(RegularSchedule, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    it 'calls FileChecker' do
      path = Rails.root.join('spec/support/fixtures/valid_location_regular_schedule.csv')

      file = double('FileChecker')
      allow(file).to receive(:validate).and_return true

      expect(FileChecker).to receive(:new).
        with(path, RegularScheduleImporter.required_headers).and_return(file)

      RegularScheduleImporter.check_and_import_file(path)
    end

    context 'with valid data' do
      it 'creates a regular_schedule' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location_regular_schedule.csv')
          RegularScheduleImporter.check_and_import_file(path)
        end.to change(RegularSchedule, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a regular_schedule' do
        allow_any_instance_of(IO).to receive(:puts)
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_regular_schedule.csv')
          RegularScheduleImporter.check_and_import_file(path)
        end.not_to change(RegularSchedule, :count)
      end
    end
  end

  describe '.required_headers' do
    it 'matches required headers in Wiki' do
      expect(RegularScheduleImporter.required_headers).
        to eq %w(id location_id service_id weekday opens_at closes_at)
    end
  end
end
