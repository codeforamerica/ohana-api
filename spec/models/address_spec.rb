require 'rails_helper'

describe Address do

  subject { build(:address) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:street) }
  it { is_expected.to allow_mass_assignment_of(:city) }
  it { is_expected.to allow_mass_assignment_of(:state) }
  it { is_expected.to allow_mass_assignment_of(:zip) }

  it { is_expected.to belong_to(:location).touch(true) }

  it { is_expected.to validate_presence_of(:street).with_message("can't be blank for Address") }
  it { is_expected.to validate_presence_of(:city).with_message("can't be blank for Address") }
  it { is_expected.to validate_presence_of(:state).with_message("can't be blank for Address") }
  it { is_expected.to validate_presence_of(:zip).with_message("can't be blank for Address") }

  it do
    is_expected.to ensure_length_of(:state).
      is_at_least(2).
      is_at_most(2).
      with_short_message('Please enter a valid 2-letter state abbreviation').
      with_long_message('Please enter a valid 2-letter state abbreviation')
  end

  it { is_expected.to allow_value('90210-1234', '22045').for(:zip) }

  it do
    is_expected.not_to allow_value('asdf').
    for(:zip).
    with_message('asdf is not a valid ZIP code')
  end

  it { is_expected.not_to allow_value('1234').for(:zip) }
  it { is_expected.not_to allow_value('123456').for(:zip) }
  it { is_expected.not_to allow_value('12346-689').for(:zip) }
  it { is_expected.not_to allow_value('90210-90210').for(:zip) }
  it { is_expected.not_to allow_value('90 210').for(:zip) }

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      address = build(:address_with_extra_whitespace)
      address.valid?
      expect(address.street).to eq('8875 La Honda Road')
      expect(address.city).to eq('La Honda')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94020')
    end
  end

  describe 'callbacks' do
    before(:each) { @loc = create(:location) }

    it 'calls reset_location_coordinates after destroy' do
      expect(@loc.address).to receive(:reset_location_coordinates)
      @loc.address.destroy
    end
  end
end
