require 'rails_helper'

describe HolidayScheduleImporter do
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_holiday_schedule.csv') }
  let(:invalid_date) { Rails.root.join('spec/support/fixtures/hs_with_invalid_date.csv') }
  let(:valid_content) do
    Rails.root.join('spec/support/fixtures/valid_location_holiday_schedule.csv')
  end
  let(:valid_service_holiday_schedule) do
    Rails.root.join('spec/support/fixtures/valid_service_holiday_schedule.csv')
  end
  let(:no_parent) { Rails.root.join('spec/support/fixtures/holiday_schedule_with_no_parent.csv') }
  let(:spelled_out_date) { Rails.root.join('spec/support/fixtures/hs_with_spelled_out_date.csv') }
  let(:org_with_2_digit_year) { Rails.root.join('spec/support/fixtures/hs_with_2_digit_year.csv') }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { HolidayScheduleImporter.new(content) }

  describe '#valid?' do
    context 'when the holiday_schedule content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the holiday_schedule content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Closes at can't be blank for Holiday Schedule when " \
        "open on that day"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ['Line 2: Holiday Schedule is missing a parent: Location or ' \
        'Service']

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the date is not valid' do
      let(:content) { invalid_date }

      errors = ["Line 2: End date 13/27/2014 is not a valid date, " \
                "End date can't be blank for Holiday Schedule"]

      its(:errors) { is_expected.to eq(errors) }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a holiday_schedule' do
      let(:content) { valid_content }

      it 'creates a holiday_schedule' do
        expect { importer.import }.to change(HolidaySchedule, :count).by(1)
      end

      describe 'the holiday_schedule' do
        before { importer.import }

        subject { HolidaySchedule.first }

        its(:id) { is_expected.to eq 2 }
        its(:closed) { is_expected.to eq false }
        its(:start_date) { is_expected.to eq Date.parse('January 11, 2014') }
        its(:end_date) { is_expected.to eq Date.parse('November 27, 2014') }
        its(:opens_at) { is_expected.to eq Time.utc(2000, 1, 1, 10, 00, 0) }
        its(:closes_at) { is_expected.to eq Time.utc(2000, 1, 1, 15, 00, 0) }
        its(:location_id) { is_expected.to eq 1 }
      end
    end

    context 'when the date is formatted as month, day, year' do
      let(:content) { spelled_out_date }

      describe 'the org' do
        before { importer.import }

        subject { HolidaySchedule.first }

        its(:start_date) { is_expected.to eq Date.parse('December 24, 2014') }
      end
    end

    context 'when the year only contains two digits' do
      let(:content) { org_with_2_digit_year }

      describe 'the org' do
        before { importer.import }

        subject { HolidaySchedule.first }

        its(:start_date) { is_expected.to eq Date.parse('January 2, 2014') }
      end
    end

    context 'when the holiday_schedule belongs to a service' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      let(:content) { valid_service_holiday_schedule }

      describe 'the holiday_schedule' do
        before { importer.import }

        subject { HolidaySchedule.first }

        its(:service_id) { is_expected.to eq 1 }
      end
    end

    context 'when required field for a holiday_schedule is blank' do
      let(:content) { invalid_content }

      it 'saves the valid entries and skips invalid ones' do
        expect { importer.import }.to change(HolidaySchedule, :count).by(1)
      end
    end

    context 'when the holiday_schedule already exists' do
      before do
        importer.import
      end

      let(:content) { valid_content }

      it 'does not create a new holiday_schedule' do
        expect { importer.import }.to_not change(HolidaySchedule, :count)
      end

      it 'does not generate errors' do
        expect(importer.errors).to eq []
      end
    end
  end

  describe '.check_and_import_file' do
    it 'calls FileChecker' do
      path = Rails.root.join('spec/support/fixtures/valid_location_holiday_schedule.csv')

      file = double('FileChecker')
      allow(file).to receive(:validate).and_return true

      expect(Kernel).to receive(:puts).
        with("\n===> Importing valid_location_holiday_schedule.csv")

      expect(FileChecker).to receive(:new).
        with(path, HolidayScheduleImporter.required_headers).and_return(file)

      HolidayScheduleImporter.check_and_import_file(path)
    end

    context 'with invalid data' do
      it 'outputs error message' do
        expect(Kernel).to receive(:puts).
          with("\n===> Importing invalid_holiday_schedule.csv")

        expect(Kernel).to receive(:puts).
          with("Line 2: Closes at can't be blank for Holiday Schedule when open on that day")

        path = Rails.root.join('spec/support/fixtures/invalid_holiday_schedule.csv')
        HolidayScheduleImporter.check_and_import_file(path)
      end
    end
  end

  describe '.required_headers' do
    it 'matches required headers in Wiki' do
      expect(HolidayScheduleImporter.required_headers).
        to eq %w(id location_id service_id closed start_date end_date opens_at
                 closes_at)
    end
  end
end
