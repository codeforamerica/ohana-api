require 'rails_helper'

describe HolidaySchedule do
  subject { build(:holiday_schedule) }

  it { is_expected.to_not be_valid }

  it { is_expected.to belong_to(:location).optional.touch(true).inverse_of(:holiday_schedules) }
  it { is_expected.to belong_to(:service).optional.touch(true).inverse_of(:holiday_schedules) }

  it do
    is_expected.to validate_presence_of(:start_date).
      with_message("can't be blank for Holiday Schedule")
  end

  it do
    is_expected.to validate_presence_of(:end_date).
      with_message("can't be blank for Holiday Schedule")
  end

  context 'when same schedule is created for different entities' do
    it 'allows the schedule creation' do
      create(:location).holiday_schedules.
        create(attributes_for(:holiday_schedule))
      second_hs = create(:nearby_loc).holiday_schedules.
                  create(attributes_for(:holiday_schedule))
      expect(second_hs.closed).to eq(true)
    end
  end

  context 'when the entity is open' do
    it 'requires opens_at and closes_at' do
      hs = build(:holiday_schedule, closed: false)
      expect(hs).to_not be_valid
    end
  end

  describe 'conversion of string representation of opens_at to Time object' do
    it_behaves_like 'validating opens_at and closes_at values', :holiday_schedule, :opens_at
  end

  describe 'conversion of string representation of closes_at to Time object' do
    it_behaves_like 'validating opens_at and closes_at values', :holiday_schedule, :closes_at
  end
end
