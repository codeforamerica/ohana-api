require 'rails_helper'

describe Phone do
  subject { build(:phone) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:department) }
  it { is_expected.to allow_mass_assignment_of(:extension) }
  it { is_expected.to allow_mass_assignment_of(:number) }
  it { is_expected.to allow_mass_assignment_of(:number_type) }
  it { is_expected.to allow_mass_assignment_of(:vanity_number) }

  it { is_expected.to belong_to(:location).touch(true) }

  it do
    is_expected.to validate_presence_of(:number).
      with_message("can't be blank for Phone")
  end

  it { is_expected.to allow_value('703-555-1212', '800.123.4567', '711').for(:number) }

  it do
    is_expected.not_to allow_value('703-').for(:number).
      with_message('703- is not a valid US phone number')
  end

  it_behaves_like TrackChanges, :department

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      phone = build(:phone_with_extra_whitespace)
      phone.valid?
      expect(phone.department).to eq('Information')
      expect(phone.number).to eq('650 851-1210')
      expect(phone.extension).to eq('x2000')
      expect(phone.vanity_number).to eq('800-FLY-AWAY')
      expect(phone.number_type).to eq('TTY')
    end
  end
end
