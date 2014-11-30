require 'rails_helper'

describe RegularSchedule do
  subject { build(:regular_schedule) }

  it { is_expected.to_not be_valid }

  it { is_expected.to allow_mass_assignment_of(:weekday) }
  it { is_expected.to allow_mass_assignment_of(:opens_at) }
  it { is_expected.to allow_mass_assignment_of(:closes_at) }

  it { is_expected.to belong_to(:location).touch(true) }
  it { is_expected.to belong_to(:service).touch(true) }

  it do
    is_expected.to validate_presence_of(:weekday).
      with_message("can't be blank for Regular Schedule")
  end

  it do
    is_expected.to validate_presence_of(:opens_at).
      with_message("can't be blank for Regular Schedule")
  end

  it do
    is_expected.to validate_presence_of(:closes_at).
      with_message("can't be blank for Regular Schedule")
  end

  it do
    is_expected.to allow_value(3, 'Monday', 'Tue', '1', '7').for(:weekday)
  end

  it do
    is_expected.to allow_value('19:00', '5am', '7pm').for(:opens_at)
  end

  it do
    is_expected.to allow_value('10:00', '5pm', '7am').for(:closes_at)
  end

  it do
    is_expected.not_to allow_value('Monday').for(:closes_at)
  end

  it { is_expected.not_to allow_value(11).for(:weekday) }
  it { is_expected.not_to allow_value('-1').for(:weekday) }
  it { is_expected.not_to allow_value('0').for(:weekday) }

  it do
    is_expected.not_to allow_value('Freitag').for(:weekday).
      with_message('Freitag is not a valid weekday')
  end

  describe 'conversion of weekday to integer' do
    it 'converts Sunday to 7' do
      rs = build(:regular_schedule, weekday: 'Sunday')
      rs.valid?
      expect(rs.weekday).to eq(7)
    end

    it 'converts an abbreviated weekday name to its integer value' do
      rs = build(:regular_schedule, weekday: 'Fri')
      rs.valid?
      expect(rs.weekday).to eq(5)
    end

    it 'converts a String-based weekday number to its integer value' do
      rs = build(:regular_schedule, weekday: '3')
      rs.valid?
      expect(rs.weekday).to eq(3)
    end
  end

  context 'when same schedule is created for different entities' do
    it 'allows the schedule creation' do
      create(:location).regular_schedules.
        create(attributes_for(:regular_schedule))
      second_rs = create(:nearby_loc).regular_schedules.
                  create(attributes_for(:regular_schedule))
      expect(second_rs.weekday).to eq(1)
    end
  end
end
