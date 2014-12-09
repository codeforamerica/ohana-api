require 'rails_helper'

describe HolidayScheduleImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_holiday_schedule_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_holiday_schedule.csv').read }
  let(:invalid_date) { Rails.root.join('spec/support/fixtures/hs_with_invalid_date.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_location_holiday_schedule.csv').read }
  let(:valid_service_holiday_schedule) { Rails.root.join('spec/support/fixtures/valid_service_holiday_schedule.csv').read }
  let(:no_parent) { Rails.root.join('spec/support/fixtures/holiday_schedule_with_no_parent.csv').read }
  let(:spelled_out_date) { Rails.root.join('spec/support/fixtures/hs_with_spelled_out_date.csv').read }
  let(:org_with_2_digit_year) { Rails.root.join('spec/support/fixtures/hs_with_2_digit_year.csv').read }

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  subject(:importer) { HolidayScheduleImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the holiday_schedule headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the holiday_schedule content is invalid' do
      let(:content) { invalid_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the holiday_schedule headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid }
    end
  end

  describe '#errors' do
    context 'when the holiday_schedule headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { is_expected.to include('closed column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when the holiday_schedule content is not valid' do
      let(:content) { invalid_content }

      errors = ["Line 2: Closes at can't be blank for Holiday Schedule when open on that day"]

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when a parent does not exist' do
      let(:content) { no_parent }

      errors = ['Line 2: Holiday Schedule must belong to either a Location or Service']

      its(:errors) { is_expected.to eq(errors) }
    end

    context 'when the date is not valid' do
      let(:content) { invalid_date }

      errors = ['Line 2: End date 13/27/2014 is not a valid date, ' \
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

        its(:closed) { is_expected.to eq false }
        its(:start_date) { is_expected.to eq Date.parse('January 11, 2014') }
        its(:end_date) { is_expected.to eq Date.parse('November 27, 2014') }
        its(:opens_at) { is_expected.to eq DateTime.parse('January 1, 2000, 10:00') }
        its(:closes_at) { is_expected.to eq DateTime.parse('January 1, 2000, 15:00') }
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

      it 'does not create a holiday_schedule' do
        expect { importer.import }.to change(HolidaySchedule, :count).by(0)
      end
    end

    context 'when the holiday_schedule already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:location).holiday_schedules.
          create!(attributes_for(:holiday_schedule))
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
    context 'with valid data' do
      it 'creates a holiday_schedule' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_location_holiday_schedule.csv')
          HolidayScheduleImporter.check_and_import_file(path)
        end.to change(HolidaySchedule, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a holiday_schedule' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_holiday_schedule.csv')
          HolidayScheduleImporter.check_and_import_file(path)
        end.not_to change(HolidaySchedule, :count)
      end
    end

    context 'when file is missing but required' do
      it 'raises an error' do
        path = Rails.root.join('spec/support/data/holiday_schedules.csv')
        expect do
          HolidayScheduleImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end

    context 'when file is empty and required' do
      it 'raises an error' do
        expect do
          path = Rails.root.join('spec/support/fixtures/holiday_schedules.csv')
          HolidayScheduleImporter.check_and_import_file(path)
        end.to raise_error(/missing or empty/)
      end
    end
  end
end
