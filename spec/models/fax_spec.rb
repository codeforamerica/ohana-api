require 'rails_helper'

describe Fax do
  subject { build(:fax) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:number) }
  it { is_expected.to allow_mass_assignment_of(:department) }

  it { is_expected.to belong_to(:location).touch(true) }

  it do
    is_expected.to validate_presence_of(:number).
      with_message("can't be blank for Fax")
  end

  it { is_expected.to allow_value('703-555-1212', '800.123.4567').for(:number) }

  it do
    is_expected.not_to allow_value('703-').for(:number).
      with_message('703- is not a valid US fax number')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      fax = build(:fax_with_extra_whitespace)
      fax.valid?
      expect(fax.department).to eq('Department of Corrections')
      expect(fax.number).to eq('800-222-3333')
    end
  end
end
