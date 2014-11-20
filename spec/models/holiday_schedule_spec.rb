require 'rails_helper'

describe HolidaySchedule do
  subject { build(:holiday_schedule) }

  it { is_expected.to_not be_valid }

  it { is_expected.to allow_mass_assignment_of(:closed) }
  it { is_expected.to allow_mass_assignment_of(:opens_at) }
  it { is_expected.to allow_mass_assignment_of(:closes_at) }
  it { is_expected.to allow_mass_assignment_of(:start_date) }
  it { is_expected.to allow_mass_assignment_of(:end_date) }

  it { is_expected.to belong_to(:location).touch(true) }
  it { is_expected.to belong_to(:service).touch(true) }

  it do
    is_expected.to validate_presence_of(:start_date).
      with_message("can't be blank for Holiday Schedule")
  end

  it do
    is_expected.to validate_presence_of(:end_date).
      with_message("can't be blank for Holiday Schedule")
  end

  it do
    is_expected.to allow_value('19:00', '5am', '7pm').for(:opens_at)
  end

  it do
    is_expected.to allow_value('10:00', '5pm', '7am').for(:closes_at)
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
end
